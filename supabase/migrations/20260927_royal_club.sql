-- Apply in Supabase SQL editor after review. Never expose service_role to clients.
create extension if not exists pgcrypto;
create table if not exists public.rc_members (
 user_id uuid primary key references auth.users(id) on delete cascade,
 display_name text not null default 'عضو کلاب',
 referral_code text unique not null default upper(substr(encode(gen_random_bytes(6),'hex'),1,10)),
 referred_by uuid references public.rc_members(user_id),
 created_at timestamptz not null default now()
);
create table if not exists public.rc_budget (
 month date not null,
 category text not null check(category in ('purchase','game','referral','reserve')),
 cap_tickets bigint not null check(cap_tickets>=0),
 issued_tickets bigint not null default 0 check(issued_tickets>=0),
 primary key(month,category),
 check(issued_tickets<=cap_tickets)
);
create table if not exists public.rc_ledger (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references public.rc_members(user_id),
 delta bigint not null check(delta<>0),
 category text not null check(category in ('purchase','game','referral','redeem','refund','expiry','adjustment')),
 source_id text not null,
 created_at timestamptz not null default now(),
 unique(category,source_id,user_id)
);
create table if not exists public.rc_xp_events (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references public.rc_members(user_id),
 points integer not null check(points>0),
 source_id text not null unique,
 created_at timestamptz not null default now()
);
create table if not exists public.rc_prizes (
 id uuid primary key default gen_random_uuid(),
 name text not null,
 tickets_required bigint not null check(tickets_required>0),
 stock integer not null default 0 check(stock>=0),
 cost_toman bigint not null check(cost_toman>=0),
 funded boolean not null default false,
 active boolean not null default false,
 image_url text
);
create table if not exists public.rc_redemptions (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references public.rc_members(user_id),
 prize_id uuid not null references public.rc_prizes(id),
 tickets bigint not null check(tickets>0),
 status text not null default 'reserved' check(status in ('reserved','delivered','cancelled')),
 created_at timestamptz not null default now()
);
create table if not exists public.rc_weekly_winners (
 week_start date primary key,
 user_id uuid not null references public.rc_members(user_id),
 xp bigint not null,
 prize_description text not null default 'RV Lounge Imperial — self-service for six (winner + five guests)',
 awarded_at timestamptz not null default now(),
 redeemed_at timestamptz
);
create or replace view public.rc_leaderboard as
 select m.user_id,m.display_name,coalesce(sum(x.points) filter(where x.created_at>=date_trunc('week',now()) and x.created_at<date_trunc('week',now())+interval '7 days'),0)::bigint as weekly_xp
 from public.rc_members m left join public.rc_xp_events x on x.user_id=m.user_id
 group by m.user_id,m.display_name;
create index if not exists rc_xp_week_idx on public.rc_xp_events(created_at,user_id);
create index if not exists rc_ledger_user_idx on public.rc_ledger(user_id,created_at);
alter table public.rc_members enable row level security;
alter table public.rc_budget enable row level security;
alter table public.rc_ledger enable row level security;
alter table public.rc_xp_events enable row level security;
alter table public.rc_prizes enable row level security;
alter table public.rc_redemptions enable row level security;
alter table public.rc_weekly_winners enable row level security;
create policy "members read own profile" on public.rc_members for select to authenticated using(user_id=auth.uid());
create policy "members read own ledger" on public.rc_ledger for select to authenticated using(user_id=auth.uid());
create policy "members read own redemption" on public.rc_redemptions for select to authenticated using(user_id=auth.uid());
create policy "public funded prizes" on public.rc_prizes for select to authenticated using(active and funded and stock>0);
create policy "members read own weekly award" on public.rc_weekly_winners for select to authenticated using(user_id=auth.uid());
-- All writes MUST run through authenticated, audited server functions, never client table writes.
-- Seed caps: 3m purchase, 1m game, 500k referral, zero reserve.
insert into public.rc_budget(month,category,cap_tickets) values
(date_trunc('month',now())::date,'purchase',3000000),
(date_trunc('month',now())::date,'game',1000000),
(date_trunc('month',now())::date,'referral',500000),
(date_trunc('month',now())::date,'reserve',0)
on conflict(month,category) do nothing;
-- Weekly winner: server job must close each week and persist exactly one winner,
-- sorting XP descending and first timestamp reaching final score ascending.
-- No prize should be marked active until inventory and liability are funded.
