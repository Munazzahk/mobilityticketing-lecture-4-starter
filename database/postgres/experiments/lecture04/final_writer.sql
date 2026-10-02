-- Can be run multiple times, but will only insert the ticket once
-- Only run after the full implementation of the product_id column 

\set product_id 'ae5e4ce6-e4d0-40cb-b737-4be01f504197'
\set ticket_id 'LAB04-FINAL-1'
\set ticket_code 'LAB04-CODE-FINAL-1'

insert into tickets (
    id,
    user_id,
    trip_id,
    ticket_code,
    status,
    product_id,
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
    valid_from_utc,
    valid_to_utc,
    70.00,
    t.currency
from tickets t
join products p
    on p.id = :'product_id'::uuid
where t.id = 'TICKET-1';