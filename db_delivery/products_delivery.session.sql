CREATE TABLE products (
    id serial PRIMARY KEY,
    product varchar(200),
    price numeric(10, 2) NOT NULL CHECK(price > 0),
    quantity int NOT NULL CHECK(quantity > 0)
);

CREATE TABLE customers (
    id serial PRIMARY KEY,
    customer varchar(300) NOT NULL CHECK(customer != ' '),
    address varchar(300) NOT NULL CHECK(address != ' '),
    phone char(10) NOT NULL
);
CREATE TABLE contracts(
    id serial PRIMARY KEY,
    created_at timestamp DEFAULT current_timestamp
);

CREATE TABLE orders (
    id serial PRIMARY KEY,
    customer_id int REFERENCES customers(id)
);
 

ALTER TABLE orders
ADD COLUMN quantity_plan int NOT NULL CHECK(quantity_plan > 0);


ALTER TABLE orders_to_products
ADD CONSTRAINT "otp_pk" PRIMARY KEY (order_id, product_id);

INSERT INTO customers (customer, address, phone) VALUES 
('Silpo', 'Chernihiv, Shevchenko str, 25', '0502302258'),
('ATB', 'Chernihiv, Striletska str, 2B', '0674502274'),
('Kolos', 'Chernihiv, Kozatska str, 41', '0632569258');

INSERT INTO products (product, price, quantity) VALUES 
('Bread', 29, 250),
('Milk', 35, 300),
('Coffee', 150, 150),
('Salt', 20, 120),
('Tea', 50, 85),
('Orange juce', 65, 94);

INSERT INTO contracts (id)
VALUES (1), (2), (3),(4);

INSERT INTO orders (customer_id, contract_id, product_id, quantity_plan) VALUES 
(2, 3, 3, 20);

CREATE TABLE deliveries (
    id serial PRIMARY KEY,
    delivery_at timestamp DEFAULT current_timestamp
);


INSERT INTO deliveries (id)
VALUES (1), (2), (3);

CREATE TABLE deliveries_to_orders(
    delivery_id int REFERENCES deliveries(id),
    order_id int REFERENCES orders(id),
    quantity int NOT NULL CHECK(quantity > 0),
    PRIMARY KEY(delivery_id, order_id)
);

INSERT INTO deliveries_to_orders (delivery_id, order_id, quantity) VALUES 
(1, 6, 5),
(1, 7, 10),
(1, 8, 5),
(2, 8, 5),
(3, 8, 20);

--які товари і в якому замовленні отримав Колос

SELECT 
    c.customer, 
    o.id, 
    o.quantity_plan,
    dto.delivery_id,
    dto.quantity AS delivery_quantity,
    p.product,
    
    dto.quantity AS delivery_quantity
FROM customers AS c
JOIN orders AS o 
ON c.id = o.customer_id
JOIN deliveries_to_orders AS dto 
ON o.id = dto.order_id
JOIN products AS p 
ON o.product_id = p.id
WHERE c.customer ILIKE 'kolos';



