-- Staging-only banker offers. Run after 20261120_rc_staging.sql.
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
 update rc.deal_rounds set opened=array_append(opened,p_case) where id=p_round;
 return r.vals[p_case];
end $$;
revoke all on function public.rc_open_deal_case(uuid,integer) from public;
grant execute on function public.rc_open_deal_case(uuid,integer) to authenticated;
