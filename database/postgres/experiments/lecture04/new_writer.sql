-- After expansion, use this query to choose a product ID for your test.
-- select id, code, price, currency from products order by code;

-- Look up its code and store both references on the ticket.
-- Use old_writer.sql as a guide to the other required ticket fields.
-- Keep the agreed price as an input; do not copy the current catalogue price.
-- Test an unknown ID and a supplied code belonging to another product.


select id, code, price, currency
from products
order by code;

\set product_id 'b371df03-7a15-4823-ac02-721b1ff90067'
\set ticket_id 'LAB04-NEW-1'
\set ticket_code 'LAB04-CODE-NEW-1'

insert into tickets (
    id,
    user_id,
    trip_id,
    ticket_code,
    status,
    product_id,
    product_code,
    valid_from_utc,
    valid_to_utc,
    price,
    currency
)
select
    :'ticket_id',
    user_id,
    trip_id,
    :'ticket_code',
    status,
    p.id,
    p.code,
    valid_from_utc,
    valid_to_utc,
    70.00,
    t.currency
from tickets t
join products p on p.id = :'product_id'::uuid
where t.id = 'TICKET-1';