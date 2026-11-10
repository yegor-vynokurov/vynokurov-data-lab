
BEGIN;


SELECT product_id, sku, stock, price
FROM products
WHERE sku IN ('APL-IPD11-A16', 'SNY-XM5')
ORDER BY product_id ASC
FOR UPDATE;



CREATE TEMP TABLE tmp_purchased_items (
    order_id bigint NOT NULL,
    product_id bigint PRIMARY KEY,
    quantity integer NOT NULL,
    updated boolean NOT NULL DEFAULT false
) ON COMMIT DROP;



WITH new_order AS (
    INSERT INTO orders (customer_id)
    SELECT customer_id
    FROM customers
    WHERE email = 'nazar.kravets@example.com'
    RETURNING order_id
),
new_items AS (
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
    RETURNING order_id, product_id, quantity
)
INSERT INTO tmp_purchased_items (
    order_id,
    product_id,
    quantity
)
SELECT order_id, product_id, quantity
FROM new_items;



WITH changed AS (
    UPDATE products AS p
    SET stock = p.stock - t.quantity
    FROM tmp_purchased_items AS t
    WHERE p.product_id = t.product_id
      AND t.product_id = (
          SELECT MIN(product_id)
          FROM tmp_purchased_items
      )
      AND p.stock >= t.quantity
    RETURNING p.product_id
)
UPDATE tmp_purchased_items AS t
SET updated = true
FROM changed AS c
WHERE t.product_id = c.product_id;




WITH changed AS (
    UPDATE products AS p
    SET stock = p.stock - t.quantity
    FROM tmp_purchased_items AS t
    WHERE p.product_id = t.product_id
      AND t.product_id = (
          SELECT MAX(product_id)
          FROM tmp_purchased_items
      )
      AND t.product_id <> (
          SELECT MIN(product_id)
          FROM tmp_purchased_items
      )
      AND p.stock >= t.quantity
    RETURNING p.product_id
)
UPDATE tmp_purchased_items AS t
SET updated = true
FROM changed AS c
WHERE t.product_id = c.product_id;


COMMIT;
