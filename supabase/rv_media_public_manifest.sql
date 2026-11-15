-- Media assets can be published after the actual approved photo/video is
-- uploaded by project management to the public media bucket.
-- No placeholders are seeded as "real" media.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('royal-one-media','royal-one-media',true,50000000,
  array['video/mp4','image/png','image/jpeg','image/webp'])
on conflict (id) do nothing;

create table if not exists public.rv_media_assets (
  id uuid primary key default gen_random_uuid(),
  kind text not null check (kind in ('video','photo')),
  title text not null check (char_length(title) between 2 and 100),
  asset_path text not null unique check (
    char_length(asset_path) between 3 and 200 and
    position('..' in asset_path)=0 and
    asset_path !~ '^/'
  ),
  sort_order int not null default 0,
  published boolean not null default false,
  created_at timestamptz not null default now()
);
create index if not exists rv_media_published_idx
  on public.rv_media_assets(published, sort_order);
alter table public.rv_media_assets enable row level security;
revoke all on public.rv_media_assets from public, anon, authenticated;
grant select on public.rv_media_assets to anon, authenticated;
create policy rv_media_public_published_read on public.rv_media_assets
  for select to anon, authenticated using (published = true);
-- No client insert, update or delete grants.
