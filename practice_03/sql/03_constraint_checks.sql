--Помилка SQL [23505]: ERROR: duplicate key value violates unique constraint "customers_email_key" Detail: Key (email)=(olena.koval@example.com) already exists.
INSERT INTO customers (email,full_name,phone,country,city) VALUES ('olena.koval@example.com', 'somebody', '+38067124334567', 'UA', 'Тернопіль')


--Помилка SQL [23514]: ERROR: new row for relation "products" violates check constraint "products_price_check" Detail: Failing row contains (27, TB-01as233, Планшет, mama, Смартфони, 0.00, 0, t, null).
INSERT INTO products (sku,name,brand,category,price) VALUES ('TB-01as233', 'Планшет', 'mama', 'Смартфони', 0);

-- Помилка SQL [23503]: ERROR: insert or update on table "order_items" violates foreign key constraint "order_items_product_id_fkey" Detail: Key (product_id)=(25) is not present in table "products".
INSERT INTO order_items (order_id,product_id,quantity,unit_price) VALUES (1, 25, 54, 34234);

--Помилка SQL [23505]: ERROR: duplicate key value violates unique constraint "order_items_pkey" Detail: Key (order_id, product_id)=(1, 18) already exists.
INSERT INTO order_items (order_id,product_id,quantity,unit_price) VALUES (1, 18, 54, 34234);

--Помилка SQL [23514]: ERROR: new row for relation "orders" violates check constraint "orders_status_check" Detail: Failing row contains (1, 1, returned, 2025-02-20 10:29:35+02).
UPDATE orders
SET status = 'returned'
WHERE order_id = 1


--Помилка SQL [23001]: ERROR: update or delete on table "customers" violates RESTRICT setting of foreign key constraint "orders_customer_id_fkey" on table "orders" Detail: Key (customer_id)=(1) is referenced from table "orders".
DELETE FROM customers WHERE customer_id = 1;
