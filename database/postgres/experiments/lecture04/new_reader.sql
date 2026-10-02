select
    t.id,
    t.product_code,
    t.product_id,
    coalesce(p_id.id, p_code.id) as resolved_product_id,
    t.price,
    t.currency
from tickets t
left join products p_id
    on p_id.id = t.product_id
left join products p_code
    on p_code.code = t.product_code
order by t.id;