-- RC security hardening for staging; apply after 20261121 migration.
-- Fix initial signup grant and prevent duplicate sessions/replay.
create or replace function public.rc_claim_daily()
returns jsonb language plpgsql security definer set search_path = ''
as $$
declare uid uuid := auth.uid(); day_key text := 'daily:' || (now() at time zone 'UTC')::date::text;
declare inserted_count integer;
begin
 if uid is null then raise exception 'Authentication required'; end if;
 insert into rc.wallets(user_id,tickets) values(uid,20)
 on conflict(user_id) do nothing;
 -- The wallet row is initialized with 20 tickets exactly once.
 -- The signup ledger entry is audit-only; never adds another 20.
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
