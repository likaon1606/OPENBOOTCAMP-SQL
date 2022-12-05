SELECT * FROM customer;
SELECT * FROM employee;
SELECT * FROM extra;
SELECT * FROM extra_version;
SELECT * FROM manufacturer;
SELECT * FROM model;
SELECT * FROM sale;
SELECT * FROM vehicle;
SELECT * FROM version;

-- COUNT Ventas por empleado
SELECT * FROM sale s
INNER JOIN employee e ON s.id_employee = e.id;

SELECT e.name, COUNT(s.id) FROM sale s
INNER JOIN employee e ON s.id_employee = e.id
GROUP BY e.name;


-- COUNT Compras por cliente
SELECT c.email, COUNT(s.id) FROM sale s
INNER JOIN customer c ON s.id_customer = c.id
GROUP BY c.email;

-- Fabricante más vendido
SELECT * FROM sale;
SELECT * FROM vehicle;
SELECT * FROM manufacturer;

SELECT * FROM sale s
INNER JOIN vehicle v ON s.id_vehicle = v.id
INNER JOIN manufacturer m ON v.id_manufacturer = m.id;

SELECT m.name, COUNT(s.id) FROM sale s
INNER JOIN vehicle v ON s.id_vehicle = v.id
INNER JOIN manufacturer m ON v.id_manufacturer = m.id
GROUP BY m.name;


-- Modelo más vendido

-- Versión más vendido

-- Extra más vendido

-- Ventas agrupando por año, mex, día







