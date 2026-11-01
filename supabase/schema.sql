-- =====================================================================
-- Gespreneur : base de données
-- À coller une seule fois dans Supabase → SQL Editor → New query → Run
-- Chaque entrepreneur ne peut lire et modifier que SES données (RLS).
-- =====================================================================

-- Mise à jour automatique de la date de modification (sert à la synchronisation)
create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at := now();
  return new;
end $$;

-- ---------- Profil de la boutique ----------
create table if not exists public.profils (
  owner       uuid primary key default auth.uid() references auth.users on delete cascade,
  telephone   text,
  boutique    text,
  auto_on     boolean not null default false,
  auto_jours  int not null default 7,
  updated_at  timestamptz not null default now()
);

-- ---------- Articles ----------
-- "base" = stock de départ ; le stock affiché = base + achats − ventes
create table if not exists public.articles (
  owner      uuid not null default auth.uid() references auth.users on delete cascade,
  id         text not null,
  nom        text,
  pv         bigint,
  pa         bigint,
  base       bigint,
  seuil      bigint,
  photo      text,
  deleted    boolean not null default false,
  updated_at timestamptz not null default now(),
  primary key (owner, id)
);

-- ---------- Clients et fournisseurs ----------
create table if not exists public.contacts (
  owner      uuid not null default auth.uid() references auth.users on delete cascade,
  id         text not null,
  type       text check (type in ('client','fournisseur')),
  nom        text,
  tel        text,
  relance    timestamptz,
  deleted    boolean not null default false,
  updated_at timestamptz not null default now(),
  primary key (owner, id)
);

-- ---------- Ventes et achats ----------
create table if not exists public.operations (
  owner      uuid not null default auth.uid() references auth.users on delete cascade,
  id         text not null,
  type       text check (type in ('vente','achat')),
  contact_id text,
  date       timestamptz,
  lignes     jsonb,
  total      bigint,
  deleted    boolean not null default false,
  updated_at timestamptz not null default now(),
  primary key (owner, id)
);

-- ---------- Versements (paiements partiels) ----------
create table if not exists public.paiements (
  owner      uuid not null default auth.uid() references auth.users on delete cascade,
  id         text not null,
  op_id      text,
  date       timestamptz,
  montant    bigint,
  mode       text,
  deleted    boolean not null default false,
  updated_at timestamptz not null default now(),
  primary key (owner, id)
);

-- ---------- Déclencheurs, index et sécurité ----------
do $$
declare t text;
begin
  foreach t in array array['profils','articles','contacts','operations','paiements'] loop
    execute format('drop trigger if exists touch on public.%I', t);
    execute format('create trigger touch before insert or update on public.%I
                    for each row execute function public.touch_updated_at()', t);
    execute format('create index if not exists %I on public.%I (owner, updated_at)', t || '_sync_idx', t);
    execute format('alter table public.%I enable row level security', t);
    execute format('drop policy if exists "mes donnees" on public.%I', t);
    execute format('create policy "mes donnees" on public.%I for all to authenticated
                    using (owner = (select auth.uid())) with check (owner = (select auth.uid()))', t);
  end loop;
end $$;
