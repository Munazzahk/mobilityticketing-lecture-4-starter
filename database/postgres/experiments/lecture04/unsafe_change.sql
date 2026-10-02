begin;

alter table tickets
    drop constraint tickets_product_code_fk;

alter table tickets
    drop column product_code;

select
    id,
    product_code,
    price,
    currency
from tickets
order by id;

-- When error occurs, rollback the transaction to avoid leaving the database in an inconsistent state.

rollback;