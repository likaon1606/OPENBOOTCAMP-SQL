/* Sentencias DML: DATA MANIPULATION LANGUAGE **
 CRUD: 
 Create(INSERT INTO), 
 Read(SELECT FROM), 
 Update(UPDATE SET), 
 Delete(DELETE FROM)
*/

-- 1. Consultas o recuperación de datos

-- Filtrar columnas
SELECT * FROM employees;

SELECT id FROM employees;

SELECT id, email FROM employees;

SELECT email, id FROM employees;

-- Filtrar filas
SELECT * FROM employees WHERE id = 1;

SELECT * FROM employees WHERE name = 'Ariel';

SELECT * FROM employees WHERE married = 'true';

SELECT * FROM employees WHERE married = TRUE;

SELECT * FROM employees WHERE birth_date = '1990-12-25';

SELECT * FROM employees WHERE married = TRUE AND salary > 8.50;

-- 2. Inserción de datos

INSERT INTO employees(name, email) VALUES('Jazmin', 'jaz@gmail.com');

INSERT INTO employees(name, email, married, gender, salary) 
VALUES('Naty', 'naty@gmail.com', FALSE, 'F', 1500.54);

INSERT INTO employees(name, email, married, gender, salary, birth_date, start_at) 
VALUES('Zaid', 'zaid@gmail.com', FALSE, 'M', 1500.54, '1985-04-16', '10:00:00');

INSERT INTO employees(name, email, married, gender, salary, birth_date, start_at) 
VALUES('Pablo', 'prd@gmail.com', TRUE, 'M', 1500.54, '1985-04-16', '10:00:00');

INSERT INTO employees 
VALUES(8, TRUE, 'Zaid', 'zd@gmail.com', 'M', 1500.54, '1985-04-16', '10:00:00');

-- 3. Actualizar o editar

-- Actualiza todas las filas de ese campo, es una mala practica
UPDATE employees SET birth_date = '1970-03-12';

-- Actualizamos por un id o campo específico como email, nombre, etc.
UPDATE employees SET birth_date = '1980-04-16' WHERE id = 3;

UPDATE employees SET salary = 1980.98 WHERE email = 'jaz@gmail.com' RETURNING *; -- RETURNING * recupera el registro, lo muestra después de la acción solicitada

UPDATE employees SET gender = 'M', married = TRUE, start_at = '9:00:10' WHERE email = 'jaz@gmail.com';

-- 4. Borrar

-- Borra todos los registros, es una mala práctica y se debe tener cuidado
DELETE FROM employees;

DELETE FROM employees WHERE email = 'jaz@gmail.com' RETURNING * ; -- Borrar solo el dato 

DELETE FROM employees WHERE gender = 'M';

DELETE FROM employees WHERE salary < 10;

DELETE FROM employees WHERE salary IS NULL;

DELETE FROM employees WHERE gender = 'M' AND married = FALSE;

SELECT * FROM employees;











