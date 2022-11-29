-- Explorar Tablas
SELECT * FROM actor;
SELECT * FROM actor WHERE last_name = 'WAHLBERG';

SELECT * FROM address;
SELECT * FROM address WHERE district = 'California';
SELECT * FROM address WHERE district = 'California' AND postal_code = '17886';
SELECT * FROM address WHERE district = 'California' AND postal_code = '17886' OR postal_code = '2299';
SELECT * FROM address WHERE postal_code = '17886' OR postal_code = '2299';
SELECT * FROM address WHERE district = 'California' AND postal_code <= '17886';

SELECT * FROM category;
SELECT * FROM category WHERE name = 'Action';

SELECT * FROM city;
SELECT * FROM city WHERE city = 'Akron';
SELECT * FROM city WHERE city LIKE 'A%'; -- LIKE busqueda que comienza con determinado caracter ej: A% el % es un comodin, busca todas las ciudades que empiecen con A y continuan con lo que sea

SELECT * FROM country;
SELECT * FROM country WHERE country = 'Spain';

SELECT * FROM customer;
SELECT * FROM customer WHERE last_name = 'WILLIAMS';
SELECT * FROM customer WHERE activebool = FALSE; -- filtrar si alguno está desactivado
SELECT * FROM customer WHERE activebool = TRUE;

UPDATE customer SET activebool = FALSE WHERE customer_id = 1;
UPDATE customer SET activebool = TRUE WHERE customer_id = 1;

SELECT * FROM film;
-- La busqueda de abajo no es adecuada por ser un texto muy largo
SELECT * FROM film WHERE description = 'A Epic Drama of a Feminist And a Mad Scientist who must Battle a Teacher in The Canadian Rockies'
SELECT * FROM film WHERE description LIKE '%Drama%' -- Contiene la palabra 'Drama'

SELECT * FROM film_actor;
SELECT * FROM film_actor WHERE film_id = 1;
SELECT * FROM film_actor WHERE actor_id = 1;

SELECT * FROM film_category;

SELECT * FROM inventory;

SELECT * FROM language;
SELECT * FROM payment;
SELECT * FROM rental;
SELECT * FROM staff;

-- Insertar datos en tabla existente
SELECT * FROM actor; -- solo es para consultar los datos
INSERT INTO actor (first_name, last_name) VALUES ('arielito', 'Fuentes');

SELECT * FROM customer;
SELECT * FROM address;
SELECT * FROM store;

INSERT INTO address (address, district, city_id, postal_code, phone) 
VALUES ('calle falsa', 'Nueva América', 300, '28004', '12312312');

-- address 606

INSERT INTO customer (store_id, first_name, last_name, email, address_id, activebool, create_date)
VALUES (1, 'customer new', 'last name example', 'example@gmail.com', 606, TRUE, '2022-01-01');





