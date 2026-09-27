-- Execute from a trusted server job shortly after each Monday 00:00 (database timezone UTC).
-- Weekly period: Monday 00:00 UTC through next Monday 00:00 UTC.
-- The prize is exactly one six-person RV Lounge Imperial self-service experience.
create or replace function public.rc_finalize_previous_week()
returns table(winner_user uuid, winner_xp bigint, awarded_week date)
language plpgsql security definer set search_path=public as $$
declare v_start timestamptz:=date_trunc('week',now())-interval '7 days';
begin
 if auth.role()<>'service_role' then raise exception 'server only'; end if;
 return query
 with ordered as (
  select x.user_id,x.created_at,x.id,
   sum(x.points) over(partition by x.user_id order by x.created_at,x.id rows unbounded preceding)::bigint as running_xp
  from rc_xp_events x
  where x.created_at>=v_start and x.created_at<v_start+interval '7 days'
 ), totals as (
  select o.user_id,max(o.running_xp) as xp,
   max(o.created_at) as reached_at
  from ordered o group by o.user_id
 ), ranked as (
  select t.user_id,t.xp,t.reached_at from totals t
  order by t.xp desc,t.reached_at asc,t.user_id asc limit 1
 ), inserted as (
  insert into rc_weekly_winners(week_start,user_id,xp)
  select v_start::date,r.user_id,r.xp from ranked r
  on conflict(week_start) do nothing
  returning rc_weekly_winners.user_id,rc_weekly_winners.xp,rc_weekly_winners.week_start
 )
 select i.user_id,i.xp,i.week_start from inserted i;
end $$;
revoke all on function public.rc_finalize_previous_week() from public,anon,authenticated;
grant execute on function public.rc_finalize_previous_week() to service_role;
-- Operational requirements:
-- 1. Schedule trusted backend cron after week close; reruns are idempotent.
-- 2. Winner's experience is issued only after an approved reservation slot is selected.
-- 3. Obtain consent before showing a member's public display name.
-- 4. XP should be issued only after server-side game verification.
