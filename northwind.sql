/*
 IMPORTAR BASE DE DATOS: en cmd escribimos: 
 psql -U postgres -d northwind < northwind.sql,
 					-nombre de < nombre del archivo descargado.sql	
					la base de
					datos
 1. Crear base de datos en postgres
 2. ejecutar el comando de recuperación de la base de datos	 
*/

-- Conocer el peso de una base de datos
SELECT pg_size_pretty (pg_database_size('northwind'))-- 9457kB
SELECT pg_size_pretty (pg_database_size('pagila')) -- 16MB

-- Para ver el tamaño de todas las bases dentro de pgadmin
SELECT pg_database.datname, pg_size_pretty (pg_database_size(pg_database.datname)) AS SIZE FROM pg_database;

-- ver el tamaño de las tablas
SELECT pg_size_pretty(pg_relation_size('orders'))-- 112 kB

-- Ver el tamaño de las 10 tablas que mas ocupan espacio
SELECT
	relname AS "relation",
	pg_size_pretty (
		pg_total_relation_size (C .oid)
	) AS "total_size"
FROM
	pg_class C
LEFT JOIN pg_namespace N ON (N.oid = C .relnamespace)
WHERE
	nspname NOT IN (
		'pg_catalog',
		'information_schema'
	)
AND C .relkind <> 'i'
AND nspname !~ '^pg_toast'
ORDER BY
	pg_total_relation_size (C .oid) DESC
LIMIT 10;

/*
	Ver el Schema en el que estamos
*/
SELECT current_schema();

/*
Ver todas las vistas materializadas en nuestra base de datos
*/

SELECT * FROM pg_matviews;

/*
	CARGAR EXTENSIONES
*/

CREATE EXTENSION pgcrypto;

SELECT * FROM employees;
INSERT INTO employees (employee_id, last_name, first_name, notes) VALUES
(11, 'em', 'Empl0', pgp_sym_encrypt('Empl0', 'password'));

/*
	Consultas joins
*/

SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM shippers;
SELECT * FROM employees;

SELECT o.order_id, c.contact_name FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- Sacar el nombre de contacto y nombre de compañia
SELECT o.order_id, c.contact_name, s.company_name FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN shippers s ON o.ship_via = s.shipper_id;

-- LEFT JOIN
SELECT c.contact_name, o.order_id FROM customers c 
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- RIGHT JOIN
SELECT c.contact_name, o.order_id FROM customers c 
RIGHT JOIN orders o ON c.customer_id = o.customer_id;

SELECT o.order_id, e. first_name, e.last_name FROM orders o
INNER JOIN employees e ON o.employee_id = e.employee_id;

-- GROUP BY
SELECT city, COUNT(customer_id) AS num_customers FROM customers GROUP BY city;
SELECT city, COUNT(customer_id) AS num_customers FROM customers GROUP BY city ORDER BY city;
SELECT city, COUNT(customer_id) AS num_customers FROM customers GROUP BY city ORDER BY num_customers;
SELECT city, COUNT(customer_id) AS num_customers FROM customers GROUP BY city ORDER BY num_customers DESC;

SELECT country, COUNT(customer_id) AS num_customers FROM customers GROUP BY country;
SELECT country, COUNT(customer_id) AS num_customers FROM customers GROUP BY country ORDER BY country;
SELECT country, COUNT(customer_id) AS num_customers FROM customers GROUP BY country ORDER BY num_customers DESC;

-- Buscar las ventas en base al cargo del empleado y ordenar por ordenes
SELECT e.title, COUNT(o.order_id) AS num_orders FROM orders o
INNER JOIN employees e ON o.employee_id = e.employee_id
GROUP BY e.title
ORDER BY num_orders;

-- Ordenar las ventas por nombre de empleado
SELECT e.first_name, e.last_name, COUNT(o.order_id) AS num_orders FROM orders o
INNER JOIN employees e ON o.employee_id = e.employee_id
GROUP BY e.first_name, e.last_name
ORDER BY num_orders;

/*
	VISTAS:
	- Son una forma de guardar las consultas SQL bajo un udentificador para ejecutarlas
	de manera mas sencilla sin tener que repetir todo el código SQL
*/

CREATE VIEW num_orders_by_employee AS
SELECT e.first_name, e.last_name, COUNT(o.order_id) AS num_orders FROM orders o
INNER JOIN employees e ON o.employee_id = e.employee_id
GROUP BY e.first_name, e.last_name
ORDER BY num_orders DESC;

-- Ya no escribiriamos todo el código de arriba
-- para saber las ventas por empleado
SELECT * FROM num_orders_by_employee;



-------------------------
/*
	VISTAS MATERIALIZADAS
	- Es más rápida la respuesta
	- Guardan físicamente el resultado de una query y actualizan los datos periódicamente
	- Cachean el resultado de una query compleja y permiten refrescarlo
	- Para crear una vista materializada cargando datos tenemos la opción WITH DATA
	
CREATE MATERIALIZED VIEW [IF NOT EXISTS] view_name AS 
query
WITH [NO] DATA;
*/
--------------------------

CREATE MATERIALIZED VIEW mv_num_orders_by_employee AS 
SELECT e.first_name, e.last_name, COUNT(o.order_id) AS num_orders FROM orders o
INNER JOIN employees e ON o.employee_id = e.employee_id
GROUP BY e.first_name, e.last_name
ORDER BY num_orders DESC
WITH DATA;

SELECT * FROM mv_num_orders_by_employee;

SELECT * FROM order_details;

CREATE TABLE example (
	id INT,
	name VARCHAR
);

------------------------------------
/*
	generate_series:
	- Genera datos demo en una tabla
*/
-------------------------------------

SELECT * FROM example;
SELECT * FROM generate_series(1, 10);

-- Insertar datos ficticios en una tabla
-- datos de 1 a 500 mil datos
INSERT INTO example(id)
SELECT * FROM generate_series(1, 500000);

CREATE MATERIALIZED VIEW mv_example AS
SELECT * FROM example
WITH DATA;

SELECT * FROM mv_example;

-- Cuando trabajmos con un dato exclusiivo hay que indicar el tipo de dato
SELECT * FROM generate_series(
	'2022-01-01 00:00:'::timestamp,-- fecha de inicio
	'2022-12-25 00:00',-- fecha final
	'6 hours'-- cada 6 horas
);



-------------------------------------
/*
	OPTIMIZAR LOS TIEMPOS DE CONSULTA
*/
--------------------------------------



-- EXPLAIN ANALYZE: Muestra el query planner y ver los tiempos
-- ANALIZAR LA PLANIFICACIÓN DE LA CONSULTA


EXPLAIN ANALYZE SELECT * FROM order_details WHERE unit_price < 10;
CREATE INDEX idx_order_details_unit_price ON order_details(unit_price) WHERE unit_price < 10;

EXPLAIN ANALYZE SELECT * FROM num_orders_by_employee;
EXPLAIN ANALYZE SELECT * FROM orders;

--------------------------------------------------------------------------------------
/*
	INDICES
	- Estructuras de datos que permiten optimizar las consultas en base a una columna
	o filtro particular, con el fin de evitar escaneo secuencial de toda la tabla
*/
----------------------------------------------------------------------------------------

CREATE INDEX idx_orders_pk ON orders(order_id);
EXPLAIN ANALYZE SELECT * FROM orders;

EXPLAIN ANALYZE SELECT * FROM example;
CREATE INDEX idx_example_pk ON example(id);

EXPLAIN ANALYZE SELECT * FROM example WHERE id = 456777;



-----------------------------------
/*
	PARTICIONAMIENTO DE TABLAS:
	- Técnica que permite dividir una misma tabla en múltiples particiones
	con el objetivo de optimizar las consultas
	
	HAY 3 TIPOS:
	1. Rango
	2. Lista
	3. Hash
*/
-----------------------------------

-- Crear la tabla base
CREATE TABLE users(
	id BIGSERIAL,
	birth_date DATE NOT NULL,
	first_name VARCHAR(20) NOT NULL,
	PRIMARY KEY(id, birth_date)
) PARTITION BY RANGE (birth_date);

-- Particiones
CREATE TABLE users_2020 PARTITION OF users
FOR VALUES FROM ('2020-01-01') TO ('2021-01-01');

CREATE TABLE users_2021 PARTITION OF users
FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');

CREATE TABLE users_2022 PARTITION OF users
FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');

INSERT INTO users(birth_date, first_name) VALUES
('2020-01-15', 'User1'),
('2020-06-15', 'User2'),
('2021-02-15', 'User3'),
('2021-11-15', 'User4'),
('2022-04-15', 'User5'),
('2020-12-15', 'User6');

SELECT * FROM users_2020;
SELECT * FROM users_2021;
SELECT * FROM users_2022;

EXPLAIN ANALYZE SELECT * FROM users;
EXPLAIN ANALYZE SELECT * FROM users WHERE birth_date = '2020-06-15';-- Ignora las demás tablas y solo busca en la 2020
EXPLAIN ANALYZE SELECT * FROM users WHERE birth_date = '2021-02-15';
EXPLAIN ANALYZE SELECT * FROM users WHERE birth_date > '2021-02-14' AND birth_date < '2022-12-16';

-- Extraer los cumpleaños del mes de Junio
EXPLAIN ANALYZE SELECT * FROM users WHERE EXTRACT(MONTH FROM birth_date) = 6 AND EXTRACT(YEAR FROM birth_date) = 2020;























