DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS films;

CREATE TABLE films (
  title VARCHAR(50),
  price INT8,
  id SERIAL8 PRIMARY KEY
);

CREATE TABLE customers (
  name VARCHAR(50),
  funds INT8,
  id SERIAL8 PRIMARY KEY
);

CREATE TABLE tickets (
  customer_id INT8 REFERENCES customers(id),
  film_id INT8 REFERENCES films(id),
  id SERIAL8 PRIMARY KEY
);
