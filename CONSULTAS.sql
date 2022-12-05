/*
	DISTINCT
*/

-- 604 resultados
SELECT * FROM address; 

-- 604 resultados
SELECT district FROM address;

-- Obtener distritos únicos (ELIMINAR DUPLICADOS)
-- 379 RESULTADOS, ya no aparecen duplicados
SELECT DISTINCT district FROM address;

-- 592 resultados
SELECT first_name FROM customer;

SELECT DISTINCT first_name FROM customer;

/*
	AND, OR, NOT
	AND:  se tienen que cumplir si o si las condiciones
	OR: se puede cumplir solo una condición
	NOT: niega una condición
	ORDER BY: Permite ordenar
*/

SELECT * FROM address WHERE district = 'California';

SELECT * FROM address WHERE district != 'California';
SELECT * FROM address WHERE NOT district = 'California';
SELECT * FROM address WHERE NOT district = 'California' ORDER BY district;

SELECT * FROM address WHERE district = 'Abu Dhabi' OR district = 'California';
SELECT * FROM address WHERE district = 'Abu Dhabi' OR district = 'California' ORDER BY district;

-- ** QUITAR LOS CAMPOS NULOS Y VACIOS **
SELECT * FROM address WHERE district IS NOT NULL ORDER BY district;
SELECT * FROM address WHERE NOT district = '';
SELECT * FROM address WHERE district IS NOT NULL AND NOT district = '' ORDER BY district;

SELECT * FROM address WHERE address2 IS NOT NULL OR address_id = 239 ORDER BY district;
SELECT * FROM address WHERE address2 IS NOT NULL AND address_id = 239 ORDER BY district;

/*
	GROUP BY: Permite agrupar en base a una columna
*/

-- muestra la columna address_id y district de la tabla address
SELECT address_id, district FROM address;
-- cuenta cuantas veces se repiten los district de la tabla address del grupo district y ordenador por district
SELECT district, COUNT(district) FROM address GROUP BY district ORDER BY district;
-- poner alias con 'AS' para que lo muestre en la tabla con otro nombre en lugar de count
SELECT district, COUNT(district) AS num FROM address GROUP BY district ORDER BY district;

SELECT * FROM actor;
SELECT last_name, COUNT(last_name) FROM actor GROUP BY last_name;

--------------------------------------------------
-- ** HAVING: filtrar datos más especificamente **
--------------------------------------------------

-- Filtrar los apellidos que se repitan 2 o más veces
SELECT last_name, COUNT(last_name) FROM actor GROUP BY last_name HAVING COUNT(last_name) > 1;

-- Obtener en cuantas películas actúa cada actor
SELECT * FROM film_actor;
SELECT * FROM film;

SELECT f.title, COUNT(fa.actor_id) FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY f.title;

-- Stock de una película en base a su título
SELECT * FROM inventory;

-- Contar cuantas películas hay de cada título 
SELECT f.title, COUNT(i.inventory_id) AS unidades FROM film f
INNER JOIN inventory i ON i.film_id = f.film_id
GROUP BY title;

-- ordenarlas de menor a mayo con ORDER BY
SELECT f.title, COUNT(i.inventory_id) AS unidades FROM film f
INNER JOIN inventory i ON i.film_id = f.film_id
GROUP BY title ORDER BY unidades;

-- Ordenar de mayor a menor
SELECT f.title, COUNT(i.inventory_id) AS unidades FROM film f
INNER JOIN inventory i ON i.film_id = f.film_id
GROUP BY title ORDER BY unidades DESC;

-- Contar cuantas películas hay de un determinado título
SELECT f.title, COUNT(i.inventory_id) AS unidades FROM film f
INNER JOIN inventory i ON i.film_id = f.film_id
WHERE title = 'FICTION CHRISTMAS'
GROUP BY title;


/*
	SUM
*/

SELECT * FROM customer;
SELECT * FROM payment;

-- Sumar lo que ha gastado cada cliente en rentas de películas
SELECT c.email, SUM(p.amount) AS num_pagos FROM payment p
INNER JOIN customer c ON p.customer_id = c.customer_id
GROUP BY c.email;

SELECT * FROM staff;

-- Contar las ventas por empleado y sumar la cantidad de cada venta
SELECT s.first_name, COUNT(p.payment_id) AS num_ventas, SUM(p.amount) AS cantidad_ventas FROM payment p
INNER JOIN staff s ON p.staff_id = s.staff_id
GROUP BY s.first_name;




/*
	JOINS
	** INNER JOIN: solo arroja los resultados que coincidan en ambas tablas **
	INNER JOIN es la más común de utilizar
*/

SELECT * FROM customer;
SELECT * FROM address;
SELECT * FROM city;
SELECT * FROM country;

------------------------------------------------
-- ** Consulta a 2 tablas: customer y address **
------------------------------------------------

SELECT first_name, last_name, customer.address_id FROM customer 
INNER JOIN address ON customer.address_id = address.address_id;

-- Podemos abreviar los nombres de las tablas
SELECT first_name, last_name, c.address_id FROM customer c
INNER JOIN address a ON c.address_id = a.address_id; 

-- Además podemos sacar la columna que tiene el nombre de la address
SELECT first_name, last_name, customer.address_id, address FROM customer 
INNER JOIN address ON customer.address_id = address.address_id;

-- Uniendo ambas tablas para ver todas sus columnas y además usando abreviaciones como 'a' para address y 'c' para customer
SELECT * FROM customer c INNER JOIN address a ON c.address_id = a.address_id;

-- Para que no exista ambiguedad es buena práctica poner el prefijo antes del campo ej: c.email o a.email
SELECT c.email, a.address FROM customer c
INNER JOIN address a ON c.address_id = a.address_id;

-----------------------------------------------------
-- ** Consulta a 3 tablas: customer, address, city **
-----------------------------------------------------

SELECT * FROM customer cu
INNER JOIN address a ON cu.address_id = a.address_id
INNER JOIN city ci ON  a.city_id = ci.city_id;

SELECT cu.email, a.address, ci.city FROM customer cu
INNER JOIN address a ON cu.address_id = a.address_id
INNER JOIN city ci ON  a.city_id = ci.city_id;

--------------------------------------------------------------
-- ** Consulta a 4 tablas: customer, address, city, country **
--------------------------------------------------------------

SELECT cu.email, a.address, ci.city, co.country FROM customer cu
INNER JOIN address a ON cu.address_id = a.address_id
INNER JOIN city ci ON a.city_id = ci.city_id
INNER JOIN country co ON ci.country_id = co.country_id;

/*
	Función CONCAT(): Une campos, pero las tablas no se modifican
*/

SELECT * FROM actor;

SELECT first_name, last_name FROM actor;

SELECT CONCAT(first_name, ' ', last_name) FROM actor;

SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM actor;

/*
	LIKE: Busqueda a partir de una palabra o que contenga ciertas palabras
	se usa el '%' para indicar que empieza o termina con una palabra
*/

SELECT * FROM film;
-- termina con la palabra Monastery
SELECT * FROM film WHERE description LIKE '%Monastery';
-- Incluye la palabra Drama
SELECT * FROM film WHERE description LIKE '%Drama%';

SELECT * FROM actor; 
-- Apellidos que tengan dentro la 'LI' juntas en el apellido
SELECT * FROM actor WHERE last_name LIKE '%LI%';
-- PoR DEFECTO EL ORDEN ES ASCENDENTE de - a +
SELECT * FROM actor WHERE last_name LIKE '%LI%' ORDER BY last_name;
-- Orden descendente de + a -
SELECT * FROM actor WHERE last_name LIKE '%LI%' ORDER BY last_name DESC;

/*
	IN
*/

SELECT * FROM country;

SELECT * FROM country WHERE country = 'Spain';
SELECT * FROM country WHERE country = 'Spain' OR country = 'Germany';
-- Esto de abajo NO es óptima porque se hace muy larga la consulta y no es buena práctica
SELECT * FROM country WHERE country = 'Spain' OR country = 'Germany' OR country = 'France';

--------------------------------------------------
-- ** Consulta optimizada para varios elementos **
--------------------------------------------------

SELECT * FROM country WHERE country IN('Spain', 'Germany', 'France', 'Mexico');

-- Busqueda por 'id'
SELECT * FROM customer;
SELECT * FROM customer WHERE customer_id = 15;
SELECT * FROM customer WHERE customer_id IN(15, 16, 17, 18);

----------------------------------------------------------

SELECT * FROM film;
SELECT * FROM language;
SELECT DISTINCT language_id FROM film;

SELECT * FROM film f
INNER JOIN language l ON f.language_id = l.language_id;

-- Contar cuantas películas hay de cada idioma
SELECT l.name, COUNT(f.film_id) FROM film f
INNER JOIN language l ON f.language_id = l.language_id
GROUP BY l.name;

-- Cambiar idioma a algunas peliculas
UPDATE film SET language_id = 2 WHERE film_id > 100 AND film_id < 200;
UPDATE film SET language_id = 3 WHERE film_id >= 200 AND film_id < 300;
UPDATE film SET language_id = 4 WHERE film_id >= 300 AND film_id < 400;


--------------------------------------------------------------------
/*
	Sub queries: Es cuando dentro de un SELECT, se anida otro SELECT
*/
--------------------------------------------------------------------

-- Obtener las películas en Italiano sin saber el id del idioma, solo con SELECT
SELECT title FROM film
WHERE language_id = (SELECT language_id FROM language WHERE name = 'Italian');

-- Obtener las películas de 2 o más idiomas
SELECT title FROM film
WHERE language_id IN (SELECT language_id FROM language WHERE name = 'Italian' OR name = 'English');

-- Películas más alquiladas

SELECT * FROM rental;
SELECT * FROM inventory;
SELECT* FROM film;

SELECT f.title, COUNT(f.film_id) AS veces_alquilada FROM film f
INNER JOIN (SELECT * FROM inventory i
INNER JOIN rental r ON r.inventory_id = i.inventory_id) res ON res.film_id = f.film_id
GROUP BY f.title 
ORDER BY veces_alquilada DESC;-- Ordenar por de mayor a menor en numero de veces alquilada








