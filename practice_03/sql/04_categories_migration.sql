BEGIN;

CREATE TABLE categories (
    category_id  bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name     text NOT NULL UNIQUE
);

ALTER TABLE products ADD COLUMN category_id bigint REFERENCES categories (category_id) ON DELETE RESTRICT;


WITH new_categories AS (
    INSERT INTO categories (name)
    VALUES
        ('Смартфони'),
        ('Навушники'),
        ('Розумні годинники'),
        ('Ноутбуки'),
        ('Планшети')
    RETURNING category_id, name
)


UPDATE products AS p
SET category_id = c.category_id
FROM new_categories AS c
WHERE p.category = c.name;



ALTER TABLE products ALTER COLUMN category_id SET NOT NULL;

ALTER TABLE products DROP COLUMN category;

COMMIT;


