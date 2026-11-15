-- Royal One / Royal Village: request intake, NOT automatic booking confirmation.
-- Customer data is readable by that verified customer only. Management reviews
-- requests through the private Supabase project dashboard.
create table if not exists public.rv_reservation_requests (
  id uuid primary key default gen_random_uuid(),
  requester_id uuid not null references auth.users(id) on delete cascade,
  salon_name text not null check (char_length(salon_name) between 3 and 100),
  customer_name text not null check (char_length(customer_name) between 3 and 120),
  phone text not null check (phone ~ '^\\+[0-9]{7,15}$'),
  reservation_date date not null,
  reservation_time time without time zone not null check (
    reservation_time >= time '07:00' and reservation_time < time '24:00'
  ),
  guest_count integer not null check (guest_count between 1 and 30),
  design text not null default '' check (char_length(design) <= 100),
  cake text not null default '' check (char_length(cake) <= 100),
  music text not null default '' check (char_length(music) <= 120),
  note text not null default '' check (char_length(note) <= 1000),
  status text not null default 'pending'
    check (status in ('pending','confirmed','declined','cancelled')),
  management_note text check (management_note is null or char_length(management_note) <= 500),
  reviewed_at timestamptz,
  created_at timestamptz not null default now()
);
create index if not exists rv_reservations_when_idx
  on public.rv_reservation_requests (reservation_date, reservation_time);
create index if not exists rv_reservations_owner_idx
  on public.rv_reservation_requests (requester_id, created_at desc);
create unique index if not exists rv_reservations_no_duplicate_open_idx
  on public.rv_reservation_requests
    (requester_id, salon_name, reservation_date, reservation_time)
  where status in ('pending','confirmed');

alter table public.rv_reservation_requests enable row level security;
revoke all on table public.rv_reservation_requests from public, anon, authenticated;
grant select, insert on table public.rv_reservation_requests to authenticated;

create policy rv_reservations_owner_read
  on public.rv_reservation_requests for select to authenticated
  using ((select auth.uid()) = requester_id);

create policy rv_reservations_verified_phone_pending_insert
  on public.rv_reservation_requests for insert to authenticated
  with check (
    (select auth.uid()) = requester_id
    and status = 'pending'
    and reviewed_at is null
    and management_note is null
    and (select auth.jwt() ->> 'phone') is not null
    and phone = (select auth.jwt() ->> 'phone')
  );
-- No UPDATE/DELETE policy or grants to mobile users: status can only be
-- changed through a privileged management workflow / Supabase dashboard.
comment on table public.rv_reservation_requests is
  'Unconfirmed Royal Village reservation requests. Pending does not reserve inventory.';
