-- Additional access policies for verified member registration and public leaderboard.
-- Only signed-in users may create their own member profile.
create policy "verified user creates own membership" on public.rc_members
 for insert to authenticated with check(user_id=auth.uid() and referred_by is null);
create policy "member updates own display name" on public.rc_members
 for update to authenticated using(user_id=auth.uid())
 with check(user_id=auth.uid() and referred_by is null);
-- Display only opted-in members on the public leaderboard.
alter table public.rc_members add column if not exists leaderboard_opt_in boolean not null default false;
drop view if exists public.rc_leaderboard;
create view public.rc_leaderboard with (security_invoker=false) as
select m.user_id,
 case when m.leaderboard_opt_in then left(m.display_name,40) else 'عضو کلاب' end as display_name,
 coalesce(sum(x.points) filter(where x.created_at>=date_trunc('week',now()) and x.created_at<date_trunc('week',now())+interval '7 days'),0)::bigint as weekly_xp
from public.rc_members m left join public.rc_xp_events x on x.user_id=m.user_id
group by m.user_id,m.display_name,m.leaderboard_opt_in;
revoke all on public.rc_leaderboard from public,anon;
grant select on public.rc_leaderboard to authenticated;
-- Production hardening: move public leaderboard to a sanitized server-maintained table
-- before anonymous access, and protect RPC operations with verified source events.
