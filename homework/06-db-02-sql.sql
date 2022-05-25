CREATE USER test_admin_user;
CREATE DATABASE test_db;

CREATE TABLE orders (id serial PRIMARY KEY, order_name varchar(30) NOT NULL, price integer NOT NULL);

CREATE TABLE clients (id serial PRIMARY KEY, last_name varchar(50) NOT NULL, country varchar(30) NOT NULL, order_number integer REFERENCES orders);

GRANT ALL ON ALL TABLES IN SCHEMA "public" TO "test_admin_user";

CREATE USER "test-simple-user";

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA "public" TO "test-simple-user";

INSERT INTO orders VALUES (1,'Шоколад',10),(2, 'Принтер', 3000),(3, 'Книга', 500),(4, 'Монитор', 7000),(5, 'Гитара', 4000);

INSERT INTO clients VALUES (1, 'Иванов Иван Иванович', 'USA'),(2, 'Петров Петр Петрович', 'Canada'),(3, 'Иоганн Себастьян Бах', 'Japan'),(4, 'Ронни Джеймс Дио', 'Russia'),(5, 'Ritchie Blackmore', 'Russia');