SET TIME ZONE 'UTC';

-- task 2.1
SELECT
	order_id,
	'Замовлення № ' || order_id AS order_label,
	created_at::date AS order_date,
	total_amount,
	installments_count,
	round(total_amount::numeric / installments_count, 2) AS monthly_payment,
	round(installments_count / 12.0, 2) AS term_years,
	CASE
		WHEN installments_count <= 4 THEN 'короткий'
		WHEN installments_count <= 6 THEN 'середній'
		ELSE 'довгий'
	END AS term_group
FROM
	shop.orders
WHERE
	country_code = 'PL'
	AND payment_method = 'installments'
	AND created_at >= TIMESTAMP '2025-12-01'
	AND created_at < TIMESTAMP '2026-01-01'
ORDER BY
	monthly_payment DESC,
	order_id;

-- task 2.2
SELECT
	shipment_id,
	order_id,
	tracking_number,
	shipped_at::date AS shipped_date,
	arrived_at::date - shipped_at::date AS transit_days,
	CASE
		WHEN returned_at IS NOT NULL THEN 'повернено'
		WHEN received_at IS NOT NULL THEN 'отримано'
		WHEN arrived_at IS NOT NULL THEN 'очікує отримання'
		WHEN shipped_at IS NOT NULL THEN 'у дорозі'
		WHEN shipped_at IS NULL THEN 'не відправлено'
	END AS state,
	COALESCE(
	    returned_at,
	    received_at,
	    arrived_at,
	    shipped_at,
	    created_at
	) AS last_event_at
FROM
	shop.shipments
WHERE
	created_at >= timestamp '2025-12-25'
	AND created_at < TIMESTAMP '2026-01-01'
ORDER BY
	last_event_at DESC,
	shipment_id;


--task 2.3
SELECT
	customer_id,
	UPPER(first_name || ' ' || last_name) AS full_name,
	COALESCE (email,
	phone) AS contact,
	CASE
		WHEN email IS NOT NULL THEN 'email'
		WHEN phone IS NOT NULL THEN 'телефон'
	END AS contact_type,
	EXTRACT(YEAR FROM birth_date)::int AS birth_year,
	CURRENT_DATE - registered_at::date AS days_registered
FROM
	shop.customers
WHERE
	country_code = 'UA'
	AND registered_at >= timestamp '2025-12-01'
	AND registered_at < timestamp '2026-01-01'
	AND (email ILIKE '%@ukr.net%'
		OR email IS NULL)
ORDER BY
	registered_at,
	customer_id;