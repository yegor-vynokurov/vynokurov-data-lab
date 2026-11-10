BEGIN;

CREATE TABLE categories (
    category_id  bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name     text NOT NULL UNIQUE
);

INSERT INTO categories (name)
VALUES ('Смартфони'),
('Навушники'),
('Розумні годинники'),
('Ноутбуки'),
('Планшети');

ALTER TABLE products ADD COLUMN category_id bigint REFERENCES categories (category_id) ON DELETE RESTRICT;

UPDATE products
SET category_id = 1
WHERE category = 'Смартфони';

UPDATE products
SET category_id = 2
WHERE category = 'Навушники';

UPDATE products
SET category_id = 3
WHERE category = 'Розумні годинники';

UPDATE products
SET category_id = 4
WHERE category = 'Ноутбуки';

UPDATE products
SET category_id = 5
WHERE category = 'Планшети';

ALTER TABLE products ALTER COLUMN category_id SET NOT NULL;

ALTER TABLE products DROP COLUMN category;

COMMIT;



