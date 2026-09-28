-- Server-only RPC: execute with service_role from trusted backend.
create or replace function public.rc_issue_tickets(
 p_user uuid,p_category text,p_source text,p_amount bigint,p_xp integer default 0
) returns uuid language plpgsql security definer set search_path=public as $$
declare v_month date:=date_trunc('month',now())::date; v_id uuid; v_daily bigint;
begin
 if auth.role() <> 'service_role' then raise exception 'server only'; end if;
 if p_category not in ('purchase','game','referral') or p_amount<=0 then raise exception 'invalid issuance'; end if;
 if exists(select 1 from rc_ledger where category=p_category and source_id=p_source and user_id=p_user) then
   select id into v_id from rc_ledger where category=p_category and source_id=p_source and user_id=p_user;
   return v_id;
 end if;
 if p_category='game' then
  select coalesce(sum(delta),0) into v_daily from rc_ledger
   where user_id=p_user and category='game' and created_at>=date_trunc('day',now());
  if v_daily+p_amount>20 then raise exception 'daily game limit'; end if;
 end if;
 if p_category='referral' then
  select count(*) into v_daily from rc_ledger where user_id=p_user and category='referral'
    and created_at>=date_trunc('month',now());
  if v_daily>=5 or p_amount<>100 then raise exception 'referral limit'; end if;
 end if;
 update rc_budget set issued_tickets=issued_tickets+p_amount
 where month=v_month and category=p_category and issued_tickets+p_amount<=cap_tickets;
 if not found then raise exception 'monthly budget exhausted'; end if;
 insert into rc_ledger(user_id,delta,category,source_id) values(p_user,p_amount,p_category,p_source) returning id into v_id;
 if p_xp>0 then insert into rc_xp_events(user_id,points,source_id) values(p_user,p_xp,p_source) on conflict(source_id) do nothing; end if;
 return v_id;
end $$;
create or replace function public.rc_redeem(p_user uuid,p_prize uuid,p_request text)
returns uuid language plpgsql security definer set search_path=public as $$
declare v_cost bigint; v_balance bigint; v_id uuid;
begin
 if auth.role()<>'service_role' then raise exception 'server only'; end if;
 if exists(select 1 from rc_ledger where user_id=p_user and category='redeem' and source_id=p_request) then
  select id into v_id from rc_redemptions where id=p_request::uuid and user_id=p_user;
  return v_id;
 end if;
 select tickets_required into v_cost from rc_prizes where id=p_prize and active and funded and stock>0 for update;
 if v_cost is null then raise exception 'prize unavailable'; end if;
 perform 1 from rc_members where user_id=p_user for update;
 select coalesce(sum(delta),0) into v_balance from rc_ledger where user_id=p_user;
 if v_balance<v_cost then raise exception 'insufficient tickets'; end if;
 update rc_prizes set stock=stock-1 where id=p_prize;
 insert into rc_redemptions(id,user_id,prize_id,tickets) values(p_request::uuid,p_user,p_prize,v_cost) returning id into v_id;
 insert into rc_ledger(user_id,delta,category,source_id) values(p_user,-v_cost,'redeem',p_request);
 return v_id;
end $$;
revoke all on function public.rc_issue_tickets(uuid,text,text,bigint,integer) from public,anon,authenticated;
revoke all on function public.rc_redeem(uuid,uuid,text) from public,anon,authenticated;
grant execute on function public.rc_issue_tickets(uuid,text,text,bigint,integer) to service_role;
grant execute on function public.rc_redeem(uuid,uuid,text) to service_role;
