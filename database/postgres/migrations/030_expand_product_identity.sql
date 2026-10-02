-- Keep the original product code contract usable.

begin;
set local lock_timeout = '3s';

create extension if not exists pgcrypto;

alter table products
    add column id uuid default gen_random_uuid();

alter table products
    add constraint products_id_unique unique (id);

alter table tickets
    add column product_id uuid;

alter table tickets
    add constraint tickets_product_id_fk
        foreign key (product_id)
        references products(id)
        not valid;

commit;