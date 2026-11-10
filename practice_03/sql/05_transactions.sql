
BEGIN;


SELECT product_id, sku, stock, price
FROM products
WHERE sku IN ('APL-IPD11-A16', 'SNY-XM5')
ORDER BY product_id ASC
FOR UPDATE;



WITH new_order AS (
    INSERT INTO orders (customer_id)
    SELECT customer_id
    FROM customers
    WHERE email = 'nazar.kravets@example.com'
    RETURNING order_id
)
INSERT INTO order_items (
    order_id,
    product_id,
    quantity,
    unit_price
)
SELECT
    o.order_id,
    p.product_id,
    q.quantity,
    p.price
FROM new_order AS o
CROSS JOIN (
    VALUES
        ('APL-IPD11-A16', 2),
        ('SNY-XM5', 1)
) AS q(sku, quantity)
JOIN products AS p
    ON p.sku = q.sku

RETURNING order_id, product_id, quantity, unit_price;



UPDATE products AS p
SET stock = p.stock - q.quantity
FROM (
    VALUES
        ('APL-IPD11-A16', 2),
        ('SNY-XM5', 1)
) AS q(sku, quantity)
WHERE p.sku = q.sku
  AND p.stock >= q.quantity

RETURNING p.product_id, p.sku, p.stock;


COMMIT;
