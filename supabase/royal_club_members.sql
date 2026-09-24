-- Run in Supabase SQL Editor after enabling Phone OTP with an SMS provider.
create table if not exists public.royal_club_members (
  user_id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null check (char_length(full_name) between 3 and 120),
  phone text not null unique check (phone ~ '^[+]989[0-9]{9}),
  accepted_terms_at timestamptz not null,
  created_at timestamptz not null default now()
);
alter table public.royal_club_members enable row level security;
create policy "member can read own record" on public.royal_club_members
 for select to authenticated using (auth.uid() = user_id);
create policy "member can insert own record" on public.royal_club_members
 for insert to authenticated with check (auth.uid() = user_id
  and phone = (auth.jwt() ->> 'phone'));
create policy "member can update own record" on public.royal_club_members
 for update to authenticated using (auth.uid() = user_id)
 with check (auth.uid() = user_id and phone = (auth.jwt() ->> 'phone'));
-- Owner: Supabase dashboard > Table Editor > royal_club_members.
-- NEVER put service_role key in the Flutter app. Restrict dashboard access.
),
  accepted_terms_at timestamptz not null,
  created_at timestamptz not null default now()
);
alter table public.royal_club_members enable row level security;
create policy "member can read own record" on public.royal_club_members
 for select to authenticated using (auth.uid() = user_id);
create policy "member can insert own record" on public.royal_club_members
 for insert to authenticated with check (auth.uid() = user_id
  and phone = (auth.jwt() ->> 'phone'));
create policy "member can update own record" on public.royal_club_members
 for update to authenticated using (auth.uid() = user_id)
 with check (auth.uid() = user_id and phone = (auth.jwt() ->> 'phone'));
-- Owner: Supabase dashboard > Table Editor > royal_club_members.
-- NEVER put service_role key in the Flutter app. Restrict dashboard access.
