SET TIME ZONE 'UTC';

-- task 4.1
SELECT
c.name AS country, 
b.name AS brand, 
count(DISTINCT o.order_id) AS orders_cnt, 
sum(oi.quantity) AS units_sold, 
sum(oi.quantity * oi.unit_price)  AS revenue 
FROM shop.brands b
JOIN shop.products p
    ON b.brand_id = p.brand_id
JOIN shop.order_items oi
    ON p.product_id = oi.product_id
JOIN shop.orders o
    ON oi.order_id = o.order_id
JOIN shop.countries c
    ON o.country_code = c.country_code

WHERE o.created_at >= timestamp '2025-10-01'
AND o.created_at < timestamp '2026-01-01' 
AND o.status = 'received'
    
GROUP BY c.name, b.name
ORDER BY c.name, revenue DESC, b.name;

-- task 4.2
SELECT
	p.product_id,
	sku,
	p.name,
	b.name AS brand,
	c.name AS category
FROM
	shop.products p
LEFT JOIN shop.order_items oi 
ON
	p.product_id = oi.product_id
LEFT JOIN shop.brands b 
ON
	p.brand_id = b.brand_id
LEFT JOIN shop.categories c 
ON
	p.category_id = c.category_id
WHERE
	quantity IS NULL
ORDER BY
	p.product_id


-- task 4.3
SELECT
	ch.category_id,
	ch.name AS category,
	pa.name AS parent,
	count(p.product_id) AS products_cnt
FROM
	shop.categories AS ch
LEFT JOIN shop.categories AS pa ON
	pa.category_id = ch.parent_id
LEFT JOIN shop.products p 
ON
	ch.category_id = p.category_id
GROUP BY
	ch.category_id,
	pa.name
ORDER BY
	ch.category_id;


-- task 4.4
SELECT
	co.name AS country,
	ca.name AS carrier,
	count(o.order_id) AS orders_cnt
FROM
	shop.countries co
CROSS JOIN shop.carriers ca
LEFT JOIN shop.orders o
ON
	ca.carrier_id = o.carrier_id
	AND co.country_code = o.country_code
	AND o.status = 'shipped'
	AND o.created_at >= timestamp '2025-12-01'
	AND o.created_at < timestamp '2026-01-01'
GROUP BY
	co.name,
	ca.name
ORDER BY
	co.name,
	ca.name;