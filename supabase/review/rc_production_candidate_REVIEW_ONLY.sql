-- REVIEW ONLY: production rollout requires a verified restorable backup.
-- WARNING: Does not provide Crown / Difference server RPCs, online leaderboard, or client integration.
-- Do not execute this candidate as a complete production rollout.
-- Dedicated rc schema; no changes to existing royal_club_* tables.

-- SOURCE: supabase/migrations/20261120_rc_staging.sql
-- Separate RC schema. Requires backup verification and transaction-based review.
-- NO public prize redemption. Review regulatory and store compliance before launch.
-- pgcrypto is already provided by Supabase; gen_random_uuid is built-in.
create schema if not exists rc;
create table if not exists rc.wallets (
 user_id uuid primary key references auth.users(id) on delete cascade,
 tickets bigint not null default 0 check (tickets >= 0),
 royal_points bigint not null default 0 check (royal_points >= 0),
 created_at timestamptz not null default now()
);
create table if not exists rc.ledger (
 id bigint generated always as identity primary key,
 user_id uuid not null references auth.users(id) on delete cascade,
 event_key text not null,
 ticket_delta bigint not null default 0,
 rp_delta bigint not null default 0,
 created_at timestamptz not null default now(),
 unique(user_id,event_key)
);
create table if not exists rc.deal_rounds (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 vals integer[] not null,
 selected_case integer,
 opened integer[] not null default '{}',
 status text not null default 'selecting' check(status in ('selecting','playing','settled')),
 banker_offer integer,
 settled_rp integer,
 created_at timestamptz not null default now(),
 check(array_length(vals,1)=26)
);
create index if not exists deal_rounds_user_idx on rc.deal_rounds(user_id,created_at desc);
alter table rc.wallets enable row level security;
alter table rc.ledger enable row level security;
alter table rc.deal_rounds enable row level security;
revoke all on schema rc from public, anon, authenticated;
revoke all on all tables in schema rc from public, anon, authenticated;
grant usage on schema rc to authenticated;
-- Expose only explicit security-definer RPCs, not mutable tables.
create or replace function public.rc_claim_daily()
returns jsonb language plpgsql security definer set search_path = ''
as $$
declare uid uuid := auth.uid(); day_key text := 'daily:' || (now() at time zone 'UTC')::date::text;
begin
 if uid is null then raise exception 'Authentication required'; end if;
 insert into rc.wallets(user_id,tickets) values(uid,20)
 on conflict(user_id) do nothing;
 -- signup grant is entered exactly once using unique event key.
 insert into rc.ledger(user_id,event_key,ticket_delta)
 values(uid,'signup',20) on conflict do nothing;
 -- Lock wallet to serialize claims and avoid concurrent double grants.
 perform 1 from rc.wallets where user_id=uid for update;
 insert into rc.ledger(user_id,event_key,ticket_delta)
 values(uid,day_key,5) on conflict do nothing;
 if found then update rc.wallets set tickets=tickets+5 where user_id=uid; end if;
 return (select jsonb_build_object('tickets',tickets,'royal_points',royal_points)
 from rc.wallets where user_id=uid);
end $$;
revoke all on function public.rc_claim_daily() from public;
grant execute on function public.rc_claim_daily() to authenticated;
-- Server-authoritative Deal rounds: random assignment never accepted from clients.
create or replace function public.rc_start_deal()
returns uuid language plpgsql security definer set search_path = ''
as $$
declare uid uuid := auth.uid(); rid uuid; shuffled integer[];
begin
 if uid is null then raise exception 'Authentication required'; end if;
 perform 1 from rc.wallets where user_id=uid for update;
 if not found then raise exception 'Claim daily tickets first'; end if;
 update rc.wallets set tickets=tickets-3 where user_id=uid and tickets>=3;
 if not found then raise exception 'Insufficient tickets'; end if;
 select array_agg(v order by random()) into shuffled
 from unnest(array[1,2,3,5,8,10,15,20,25,30,40,50,75,100,150,200,250,300,400,500,600,750,1000,1500,2000,3000]) as v;
 insert into rc.deal_rounds(user_id,vals) values(uid,shuffled) returning id into rid;
 insert into rc.ledger(user_id,event_key,ticket_delta) values(uid,'deal:start:'||rid::text,-3);
 return rid;
end $$;
revoke all on function public.rc_start_deal() from public;
grant execute on function public.rc_start_deal() to authenticated;
-- Select a case. This is irreversible and must precede opening.
create or replace function public.rc_select_deal_case(p_round uuid,p_case integer)
returns void language plpgsql security definer set search_path = ''
as $$
begin
 if auth.uid() is null or p_case not between 1 and 26 then raise exception 'Invalid selection'; end if;
 update rc.deal_rounds set selected_case=p_case,status='playing'
 where id=p_round and user_id=auth.uid() and status='selecting';
 if not found then raise exception 'Round unavailable'; end if;
end $$;
revoke all on function public.rc_select_deal_case(uuid,integer) from public;
grant execute on function public.rc_select_deal_case(uuid,integer) to authenticated;
-- Open one non-selected case; return its value, never modify RP.
create or replace function public.rc_open_deal_case(p_round uuid,p_case integer)
returns integer language plpgsql security definer set search_path = ''
as $$
declare r rc.deal_rounds%rowtype;
begin
 if auth.uid() is null or p_case not between 1 and 26 then raise exception 'Invalid case'; end if;
 select * into r from rc.deal_rounds where id=p_round and user_id=auth.uid() for update;
 if not found or r.status <> 'playing' or p_case=r.selected_case or p_case=any(r.opened)
 then raise exception 'Case unavailable'; end if;
 update rc.deal_rounds set opened=array_append(opened,p_case) where id=p_round;
 return r.vals[p_case];
end $$;
revoke all on function public.rc_open_deal_case(uuid,integer) from public;
grant execute on function public.rc_open_deal_case(uuid,integer) to authenticated;
-- Settlement for final case only; banker offer acceptance requires a separate
-- server-controlled progression function and is intentionally NOT exposed yet.
create or replace function public.rc_settle_final_case(p_round uuid)
returns integer language plpgsql security definer set search_path = ''
as $$
declare r rc.deal_rounds%rowtype; award integer;
begin
 if auth.uid() is null then raise exception 'Authentication required'; end if;
 select * into r from rc.deal_rounds where id=p_round and user_id=auth.uid() for update;
 if not found or r.status <> 'playing' or cardinality(r.opened)<>25
 then raise exception 'Round not ready for settlement'; end if;
 award := r.vals[r.selected_case];
 update rc.deal_rounds set status='settled',settled_rp=award where id=p_round;
 insert into rc.ledger(user_id,event_key,rp_delta) values(auth.uid(),'deal:settle:'||p_round::text,award);
 update rc.wallets set royal_points=royal_points+award where user_id=auth.uid();
 return award;
end $$;
revoke all on function public.rc_settle_final_case(uuid) from public;
grant execute on function public.rc_settle_final_case(uuid) to authenticated;


-- SOURCE: supabase/migrations/20261121_rc_banker_staging.sql
-- Banker offers. Review before rollout.
-- The banker cannot be invoked repeatedly at the same progression point.
alter table rc.deal_rounds add column if not exists offer_at_count integer;
alter table rc.deal_rounds add column if not exists rejected_offer_counts integer[] not null default '{}';
create or replace function public.rc_banker_offer(p_round uuid)
returns integer language plpgsql security definer set search_path = ''
as $$
declare r rc.deal_rounds%rowtype; n integer; mean_value numeric; proposed integer;
begin
 if auth.uid() is null then raise exception 'Authentication required'; end if;
 select * into r from rc.deal_rounds where id=p_round and user_id=auth.uid() for update;
 if not found or r.status <> 'playing' then raise exception 'Round unavailable'; end if;
 n:=cardinality(r.opened);
 if n not in (6,11,15,18,20,21,22,23,24) then raise exception 'Not a banker round'; end if;
 if r.offer_at_count=n then return r.banker_offer; end if;
 if n=any(r.rejected_offer_counts) then raise exception 'Offer already rejected'; end if;
 if r.offer_at_count is not null then raise exception 'Respond to previous offer'; end if;
 select avg(r.vals[i]) into mean_value from generate_series(1,26) as i
 where not(i=any(r.opened));
 proposed:=greatest(1,least(3000,round(mean_value*0.75)::integer));
 update rc.deal_rounds set banker_offer=proposed,offer_at_count=n where id=p_round;
 return proposed;
end $$;
revoke all on function public.rc_banker_offer(uuid) from public;
grant execute on function public.rc_banker_offer(uuid) to authenticated;

create or replace function public.rc_banker_decision(p_round uuid,p_accept boolean)
returns jsonb language plpgsql security definer set search_path = ''
as $$
declare r rc.deal_rounds%rowtype;
begin
 if auth.uid() is null then raise exception 'Authentication required'; end if;
 select * into r from rc.deal_rounds where id=p_round and user_id=auth.uid() for update;
 if not found or r.status <> 'playing' or r.offer_at_count is null or r.banker_offer is null
 then raise exception 'No pending banker offer'; end if;
 if p_accept then
  update rc.deal_rounds set status='settled',settled_rp=r.banker_offer where id=p_round;
  insert into rc.ledger(user_id,event_key,rp_delta)
   values(auth.uid(),'deal:settle:'||p_round::text,r.banker_offer);
  update rc.wallets set royal_points=royal_points+r.banker_offer where user_id=auth.uid();
  return jsonb_build_object('settled',true,'royal_points',r.banker_offer);
 end if;
 update rc.deal_rounds set rejected_offer_counts=array_append(rejected_offer_counts,r.offer_at_count),
 banker_offer=null,offer_at_count=null where id=p_round;
 return jsonb_build_object('settled',false,'royal_points',0);
end $$;
revoke all on function public.rc_banker_decision(uuid,boolean) from public;
grant execute on function public.rc_banker_decision(uuid,boolean) to authenticated;

-- Block case openings while the banker has an unanswered offer.
create or replace function public.rc_open_deal_case(p_round uuid,p_case integer)
returns integer language plpgsql security definer set search_path = ''
as $$
declare r rc.deal_rounds%rowtype;
begin
 if auth.uid() is null or p_case not between 1 and 26 then raise exception 'Invalid case'; end if;
 select * into r from rc.deal_rounds where id=p_round and user_id=auth.uid() for update;
 if not found or r.status <> 'playing' or r.offer_at_count is not null
 or p_case=r.selected_case or p_case=any(r.opened) or cardinality(r.opened)>=25
 then raise exception 'Case unavailable'; end if;
 if cardinality(r.opened) in (6,11,15,18,20,21,22,23,24)
    and not (cardinality(r.opened)=any(r.rejected_offer_counts))
 then raise exception 'Banker offer must be resolved first'; end if;
 update rc.deal_rounds set opened=array_append(opened,p_case) where id=p_round;
 return r.vals[p_case];
end $$;
revoke all on function public.rc_open_deal_case(uuid,integer) from public;
grant execute on function public.rc_open_deal_case(uuid,integer) to authenticated;


-- SOURCE: supabase/migrations/20261122_rc_security_fixes.sql
-- RC security hardening.
-- Fix initial signup grant and prevent duplicate sessions/replay.
create or replace function public.rc_claim_daily()
returns jsonb language plpgsql security definer set search_path = ''
as $$
declare uid uuid := auth.uid(); day_key text := 'daily:' || (now() at time zone 'UTC')::date::text;
inserted_count integer;
begin
 if uid is null then raise exception 'Authentication required'; end if;
 insert into rc.wallets(user_id,tickets) values(uid,20)
 on conflict(user_id) do nothing;
 -- Wallet signup grant is inserted once.
 -- The signup rc.ledger entry is audit-only; never adds another 20.
 perform 1 from rc.wallets where user_id=uid for update;
 insert into rc.ledger(user_id,event_key,ticket_delta)
 values(uid,'signup',20) on conflict do nothing;
 insert into rc.ledger(user_id,event_key,ticket_delta)
 values(uid,day_key,5) on conflict do nothing;
 get diagnostics inserted_count = row_count;
 if inserted_count = 1 then
  update rc.wallets set tickets=tickets+5 where user_id=uid;
 end if;
 return (select jsonb_build_object('tickets',tickets,'royal_points',royal_points)
 from rc.wallets where user_id=uid);
end $$;
revoke all on function public.rc_claim_daily() from public;
grant execute on function public.rc_claim_daily() to authenticated;

-- Each user may have only one unsettled Deal round at a time.
create unique index if not exists rc_one_active_deal_per_user
on rc.deal_rounds(user_id) where status in ('selecting','playing');

-- Bank offers are valid only after the correct number of case openings.
-- Reject forged final settlement while an offer is pending.
create or replace function public.rc_settle_final_case(p_round uuid)
returns integer language plpgsql security definer set search_path = ''
as $$
declare r rc.deal_rounds%rowtype; award integer;
begin
 if auth.uid() is null then raise exception 'Authentication required'; end if;
 select * into r from rc.deal_rounds where id=p_round and user_id=auth.uid() for update;
 if not found or r.status <> 'playing' or r.selected_case is null
 or cardinality(r.opened)<>25 or r.offer_at_count is not null
 then raise exception 'Round not ready for settlement'; end if;
 award := r.vals[r.selected_case];
 update rc.deal_rounds set status='settled',settled_rp=award where id=p_round;
 insert into rc.ledger(user_id,event_key,rp_delta)
 values(auth.uid(),'deal:settle:'||p_round::text,award);
 update rc.wallets set royal_points=royal_points+award where user_id=auth.uid();
 return award;
end $$;
revoke all on function public.rc_settle_final_case(uuid) from public;
grant execute on function public.rc_settle_final_case(uuid) to authenticated;

