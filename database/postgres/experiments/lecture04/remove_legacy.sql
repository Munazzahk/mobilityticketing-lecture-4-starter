-- Rehearse removal of the legacy product reference.
-- Run only after the ID-only reader and writer are ready.

begin;

set local lock_timeout = '3s';

-- Inspect dependencies on tickets.product_code before removing it.
-- Update or remove those dependencies deliberately.

alter table tickets
    drop constraint tickets_product_code_fk;

alter table tickets
    drop column product_code;

-- Test the final reader and writer here.
-- The old reader/writer must no longer be used.

rollback;