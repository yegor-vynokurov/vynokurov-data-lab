SET TIME ZONE 'UTC';


-- task 3.1
SELECT
	country_code,
	count(order_id) AS orders_cnt,
	count (DISTINCT customer_id) AS customers_cnt,
	sum(total_amount) AS total_sum,
	round(avg(total_amount), 2) AS avg_check,
	min(total_amount) AS min_check,
	max(total_amount) AS max_check
FROM
	shop.orders
WHERE
	status = 'received'
	AND created_at >= timestamp '2025-01-01'
	AND created_at < timestamp '2026-01-01'
	AND country_code IN ('UA', 'PL')
GROUP BY
	country_code
ORDER BY
	country_code;

-- task 3.2
SELECT
	DATE_TRUNC('month', created_at)::date AS order_month,
	count(order_id) AS orders_cnt,
	count (DISTINCT customer_id) AS customers_cnt,
	sum(total_amount) AS total_sum,
	round(avg(total_amount), 2) AS avg_check
FROM
	shop.orders
WHERE 
	country_code = 'UA'
	AND status = 'received'
GROUP BY
	order_month
ORDER BY
	order_month ASC;

--task 3.3
SELECT
	country_code,
	EXTRACT(HOUR FROM created_at AT TIME ZONE 'UTC')::int AS order_hour,
	count(order_id) AS orders_cnt,
	round(avg(total_amount), 2) AS avg_check
FROM
	shop.orders
WHERE
	status != 'cancelled'
	AND created_at >= TIMESTAMP '2025-01-01'
    AND created_at < TIMESTAMP '2026-01-01'
GROUP BY
	country_code,
	order_hour
ORDER BY
	country_code,
	order_hour;


-- task 3.4
SELECT
	customer_id,
	count(order_id) AS orders_cnt,
	sum(total_amount) AS total_sum,
	MIN(created_at)::date AS first_order_date,
	max(created_at)::date AS last_order_date
FROM
	shop.orders
WHERE
	country_code = 'UA'
	AND status = 'received'
GROUP BY
	customer_id
HAVING
	COUNT(order_id) >= 15
	AND SUM(total_amount) >= 500000
ORDER BY
	total_sum DESC,
	customer_id
LIMIT 20;