create extension if not exists "pgcrypto";

create table if not exists public.styles (
 id uuid primary key default gen_random_uuid(), name text not null, description text default '', active boolean not null default true, sort_order int not null default 0, created_at timestamptz default now()
);
create table if not exists public.portfolio (
 id uuid primary key default gen_random_uuid(), title text not null, style_id uuid references public.styles(id) on delete set null, body_area text, description text default '', image_url text, published boolean not null default true, created_at timestamptz default now()
);
create table if not exists public.faq (
 id uuid primary key default gen_random_uuid(), question text not null, answer text not null, published boolean not null default true, sort_order int not null default 0, created_at timestamptz default now()
);
create table if not exists public.booking_requests (
 id uuid primary key default gen_random_uuid(), name text not null, phone text not null, style_id uuid references public.styles(id) on delete set null, body_area text, size text, preferred_date date, notes text, status text not null default 'new', quoted_price text, created_at timestamptz default now()
);
create table if not exists public.customers (
 id uuid primary key default gen_random_uuid(), name text not null, phone text, style text, body_area text, notes text, photo_url text, created_at timestamptz default now()
);

alter table public.styles enable row level security;
alter table public.portfolio enable row level security;
alter table public.faq enable row level security;
alter table public.booking_requests enable row level security;
alter table public.customers enable row level security;

drop policy if exists "public read active styles" on public.styles;
create policy "public read active styles" on public.styles for select to anon, authenticated using (active=true);
drop policy if exists "public read portfolio" on public.portfolio;
create policy "public read portfolio" on public.portfolio for select to anon, authenticated using (published=true);
drop policy if exists "public read faq" on public.faq;
create policy "public read faq" on public.faq for select to anon, authenticated using (published=true);
drop policy if exists "public create booking" on public.booking_requests;
create policy "public create booking" on public.booking_requests for insert to anon, authenticated with check (true);
create policy "authenticated manage bookings" on public.booking_requests for all to authenticated using (true) with check (true);
create policy "authenticated manage customers" on public.customers for all to authenticated using (true) with check (true);
create policy "authenticated manage styles" on public.styles for all to authenticated using (true) with check (true);
create policy "authenticated manage portfolio" on public.portfolio for all to authenticated using (true) with check (true);
create policy "authenticated manage faq" on public.faq for all to authenticated using (true) with check (true);

insert into public.styles(name,description,sort_order) values
('Minimal & Fine Line','خطوط ظریف و مینیمال',1),('Black & Grey','مشکی و خاکستری',2),('Realism','رئال و پرتره',3),('Blackwork','مشکی و گرافیکی',4),('Cover Up','پوشاندن تتوهای قبلی',5)
on conflict do nothing;
insert into public.faq(question,answer,sort_order) values
('هزینه تتو چطور مشخص می‌شود؟','قیمت بعد از بررسی طرح، اندازه و محل اجرا اعلام می‌شود.',1),
('برای رزرو بیعانه لازم است؟','شرایط بیعانه هنگام تأیید نهایی نوبت اعلام می‌شود.',2),
('طرح اختصاصی انجام می‌دهید؟','بله؛ ایده و طرح مرجع خود را در درخواست رزرو ارسال کنید.',3)
on conflict do nothing;

insert into storage.buckets (id,name,public) values ('portfolio','portfolio',true),('customer-photos','customer-photos',false) on conflict (id) do nothing;
create policy "public portfolio images" on storage.objects for select to anon, authenticated using (bucket_id='portfolio');
create policy "authenticated upload portfolio" on storage.objects for insert to authenticated with check (bucket_id='portfolio');
create policy "authenticated customer photos" on storage.objects for all to authenticated using (bucket_id='customer-photos') with check (bucket_id='customer-photos');