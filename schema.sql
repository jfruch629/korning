DROP TABLE IF EXISTS sales CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS accounts CASCADE;
DROP TABLE IF EXISTS products CASCADE;

CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  employee_with_email VARCHAR(500) NOT NULL
);

CREATE TABLE accounts (
  id SERIAL PRIMARY KEY,
  customer_and_account_no VARCHAR(255) NOT NULL,
  invoice_frequency VARCHAR(255) NOT NULL
);

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  product_name VARCHAR(500) NOT NULL
);

CREATE TABLE sales (
  id SERIAL PRIMARY KEY,
  employee_id integer REFERENCES employees(id),
  customer_id integer REFERENCES accounts(id),
  product_id integer REFERENCES products(id),
  sale_date VARCHAR(255) NOT NULL,
  sale_amount VARCHAR(255) NOT NULL,
  units_sold INTEGER NOT NULL,
  invoice_no INTEGER NOT NULL
);
