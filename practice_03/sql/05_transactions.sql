
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





BEGIN;


WITH new_order AS (
    INSERT INTO orders (customer_id)
    VALUES (1)
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
    3,
    p.price
FROM new_order AS o
CROSS JOIN products AS p
WHERE p.sku = 'APL-MBA13-M4'
RETURNING order_id, product_id, quantity, unit_price;


UPDATE products
SET stock = stock - 3
WHERE sku = 'APL-MBA13-M4';



ROLLBACK;





BEGIN;

INSERT INTO products (
    sku, name, brand, category_id,
    price, stock, is_active
)
SELECT
    v.sku,
    v.name,
    v.brand,
    c.category_id,
    v.price,
    v.stock,
    true
FROM (
    VALUES
        ('APL-APP3', 'AirPods Pro 3', 'Apple',
         'Навушники', 11999.00, 42),

        ('SMS-S25-256', 'Galaxy S25 256GB', 'Samsung',
         'Смартфони', 35999.00, 20),

        ('GGL-PX10-128', 'Pixel 10 128GB', 'Google',
         'Смартфони', 34999.00, 15),

        ('LNV-TABP12', 'Tab P12', 'Lenovo',
         'Планшети', 15499.50, 10)
) AS v(sku, name, brand, category, price, stock)

JOIN categories AS c
    ON c.name = v.category

ON CONFLICT (sku)
DO UPDATE SET
    price = EXCLUDED.price,
    stock = EXCLUDED.stock

RETURNING
    sku,
    old.price AS old_price,
    new.price AS new_price;


