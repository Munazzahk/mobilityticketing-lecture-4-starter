select
    t.id,
    t.product_code,
    t.product_id,
    p_id.code as id_product_code,
    p_code.id as code_product_id,
    t.price,
    t.currency
from tickets t
left join products p_id
    on p_id.id = t.product_id
left join products p_code
    on p_code.code = t.product_code
where t.product_id is null
   or p_id.id is null
   or p_code.id is null
   or p_id.id <> p_code.id
order by t.id;

-- Inspect the stored references after expansion
-- Expect no rows returned. If any rows are returned, the expansion is not correct

-- Deliberately create a mismatch to test the verification query.
-- The change is rolled back and will not remain in the database.

begin;

update tickets
set product_id = (
    select p.id
    from products p
    where p.code <> tickets.product_code
    limit 1
)
where id = 'LAB04-NEW-1';

-- Run the verification query here.
-- It should return LAB04-NEW-1.

select
    t.id,
    t.product_code,
    t.product_id,
    p_id.code as id_product_code,
    p_code.id as code_product_id,
    t.price,
    t.currency
from tickets t
left join products p_id
    on p_id.id = t.product_id
left join products p_code
    on p_code.code = t.product_code
where t.product_id is null
   or p_id.id is null
   or p_code.id is null
   or p_id.id <> p_code.id
order by t.id;

-- Rollback the change to restore the database to its original state

rollback;