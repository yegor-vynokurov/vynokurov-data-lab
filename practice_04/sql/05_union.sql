SET TIME ZONE 'UTC';

-- task 5.1
SELECT
	created_at AS event_at,
	'замовлення створено' AS EVENT,
	total_amount AS amount
FROM
	shop.orders
WHERE
	order_id = 271060
UNION ALL

SELECT
	created_at AS event_at,
	CASE
		WHEN status = 'failed' THEN 'платіж відхилено'
		WHEN status = 'succeeded' THEN 'платіж успішний'
	END AS EVENT,
	amount AS amount
FROM
	shop.payments
WHERE
	order_id = 271060
	AND status IN ('failed', 'succeeded')
UNION ALL

SELECT
	shipped_at AS event_at,
	'відправлено' AS EVENT,
	NULL AS amount
FROM
	shop.shipments
WHERE
	order_id = 271060
	AND shipped_at IS NOT NULL
UNION ALL

SELECT
	received_at AS event_at,
	'отримано' AS EVENT,
	NULL AS amount
FROM
	shop.shipments
WHERE
	order_id = 271060
	AND received_at IS NOT NULL
ORDER BY
	event_at;


-- task 5.2
SELECT
	country_code,
	'замовлення' AS metric,
	sum(total_amount) AS amount
FROM
	shop.orders
WHERE
	created_at >= TIMESTAMP '2025-12-01'
	AND created_at < TIMESTAMP '2026-01-01'
GROUP BY
	country_code
UNION ALL

SELECT
	country_code,
	'позиції' AS metric,
	sum(oi.unit_price * oi.quantity) AS amount
FROM
	shop.order_items oi
JOIN shop.orders o
ON
	oi.order_id = o.order_id
WHERE
	o.created_at >= TIMESTAMP '2025-12-01'
	AND o.created_at < TIMESTAMP '2026-01-01'
GROUP BY
	country_code
UNION ALL

SELECT
	country_code,
	'успішні платежі' AS metric,
	sum(p.amount) AS amount
FROM
	shop.payments p
JOIN shop.orders o
ON
	p.order_id = o.order_id
	AND p.status = 'succeeded'
	AND p.payment_type = 'payment'
WHERE
	o.created_at >= TIMESTAMP '2025-12-01'
	AND o.created_at < TIMESTAMP '2026-01-01'
GROUP BY
	country_code
ORDER BY
	country_code,
	metric;
