create extension if not exists "pgcrypto";

create table if not exists public.listings (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(title) between 1 and 120),
  description text not null check (char_length(description) between 1 and 2000),
  price numeric(12, 2) not null check (price >= 0),
  email text not null check (char_length(email) <= 254),
  category text not null,
  photo_url text not null,
  created_at timestamptz not null default now()
);

alter table public.listings enable row level security;
grant select, insert on public.listings to anon, authenticated;

drop policy if exists "Anyone can read listings" on public.listings;
create policy "Anyone can read listings"
  on public.listings for select
  to anon, authenticated
  using (true);

drop policy if exists "Anyone can create listings" on public.listings;
create policy "Anyone can create listings"
  on public.listings for insert
  to anon, authenticated
  with check (true);

create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid references public.listings(id) on delete set null,
  listing_title text not null,
  seller_email text,
  buyer_email text not null check (char_length(buyer_email) <= 254),
  message text not null check (char_length(message) between 2 and 2000),
  created_at timestamptz not null default now()
);

alter table public.messages enable row level security;
grant insert on public.messages to anon, authenticated;

drop policy if exists "Anyone can send seller messages" on public.messages;
create policy "Anyone can send seller messages"
  on public.messages for insert
  to anon, authenticated
  with check (true);

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('listing-photos', 'listing-photos', true, 10485760, array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "Anyone can view listing photos" on storage.objects;
create policy "Anyone can view listing photos"
  on storage.objects for select
  to anon, authenticated
  using (bucket_id = 'listing-photos');

drop policy if exists "Anyone can upload listing photos" on storage.objects;
create policy "Anyone can upload listing photos"
  on storage.objects for insert
  to anon, authenticated
  with check (bucket_id = 'listing-photos');
