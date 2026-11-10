DROP TABLE IF EXISTS customers, products, orders, order_items, categories;

CREATE TABLE customers (
    customer_id   bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email         text NOT NULL UNIQUE,
    full_name     text NOT NULL,
    city          text NOT NULL,
    phone         text,
    country       text NOT NULL CHECK (country IN ('UA', 'PL')),
    registered_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE products (
    product_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sku       text NOT NULL UNIQUE,
    name      text NOT NULL,
    brand     text NOT NULL,
    category  text NOT NULL,
    price     numeric(10,2) NOT NULL CHECK (price > 0), 
    stock     int NOT NULL CHECK (stock >= 0) DEFAULT 0, 
    is_active boolean NOT NULL DEFAULT true,
    attributes jsonb 
);


CREATE TABLE orders (
    order_id          bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id       bigint NOT NULL REFERENCES customers (customer_id) ON DELETE RESTRICT,
    status            text NOT NULL DEFAULT 'new' CHECK (status in ('new', 'paid', 'shipped', 'delivered', 'cancelled')),
    created_at        timestamptz NOT NULL DEFAULT now()
);


CREATE TABLE order_items  (
    order_id       bigint REFERENCES orders (order_id) ON DELETE CASCADE,
    product_id     bigint NOT NULL REFERENCES products (product_id) ON DELETE RESTRICT,
                   PRIMARY KEY (order_id, product_id),
    quantity      int NOT NULL CHECK (quantity > 0),
    unit_price     numeric(10,2) NOT NULL CHECK (unit_price > 0)
);