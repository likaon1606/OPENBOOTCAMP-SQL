-- MANUFACTURER

CREATE TABLE manufacturer(
	id SERIAL,
	name VARCHAR(50) NOT NULL,
	num_employees INT,
	CONSTRAINT pk_manufacturer PRIMARY KEY(id)
);

SELECT * FROM manufacturer;

INSERT INTO manufacturer (name, num_employees)
VALUES ('Ford', 29000);

INSERT INTO manufacturer (name, num_employees)
VALUES ('Toyota', 45000);

-- MODEL

CREATE TABLE model(
	id SERIAL,
	name VARCHAR(50) NOT NULL,
	id_manufacturer INT, -- Para relacionarlo con la tabla 'manufacturer'
	CONSTRAINT pk_model PRIMARY KEY(id),
	CONSTRAINT fk_model_manufacturer FOREIGN KEY(id_manufacturer) REFERENCES manufacturer(id) -- Apuntamos a la llave foranea de la tabla manufacturer
);

SELECT * FROM model;

INSERT INTO model (name, id_manufacturer) VALUES ('Mondeo', 1);
INSERT INTO model (name, id_manufacturer) VALUES ('Fiesta', 1);
INSERT INTO model (name, id_manufacturer) VALUES ('Prius', 2);

-- VERSION

CREATE TABLE IF NOT EXISTS version(-- Es buena práctica poner el IF NOT EXISTS por si ya exixtiera la tabla
	id SERIAL,
	name VARCHAR(50) NOT NULL,
	engine VARCHAR(50),
	price NUMERIC,
	cc NUMERIC(2,1),
	id_model INT,
	CONSTRAINT pk_version PRIMARY KEY(id),
	CONSTRAINT fk_version_model FOREIGN KEY(id_model) REFERENCES model(id) ON UPDATE SET NULL ON DELETE SET NULL
);
SELECT * FROM version

INSERT INTO version (name, engine, price, cc, id_model)VALUES ('Basic', 'Diesel 4C', 3000, 1.9, 1);
INSERT INTO version (name, engine, price, cc, id_model)VALUES ('Medium', 'Diesel 5C', 5000, 2.2, 1);
INSERT INTO version (name, engine, price, cc, id_model)VALUES ('Advance', 'Diesel 6C V', 8000, 3.2, 1);

INSERT INTO version (name, engine, price, cc, id_model)VALUES ('Sport', 'Gasolina 4C', 50000, 2.1, 2);
INSERT INTO version (name, engine, price, cc, id_model)VALUES ('Sport Advance', 'Gasolina 8C', 90000, 3.2, 2);

-- EXTRA
CREATE TABLE IF NOT EXISTS extra(
	id SERIAL,
	name VARCHAR(50) NOT NULL,
	description VARCHAR(300),
	CONSTRAINT pk_extra PRIMARY KEY(id)
);
SELECT * FROM extra

CREATE TABLE extra_version(
	id_version INT,
	id_extra INT,
	price NUMERIC NOT NULL CHECK (price >= 0),
	CONSTRAINT pk_extra_version PRIMARY KEY(id_version, id_extra), -- Llave primaria compuesta
	CONSTRAINT fk_version_extra FOREIGN KEY(id_version) REFERENCES version(id) ON UPDATE cascade ON DELETE cascade,
	CONSTRAINT fk_extra_version FOREIGN KEY(id_extra) REFERENCES extra(id) ON UPDATE cascade ON DELETE cascade -- ON UPDATE cascade ON DELETE cascade, BORRA LA TABLA ENTERA
);
SELECT * FROM extra_version

INSERT INTO extra(name, description) VALUES ('Techo solar', 'Techo solar flamante ...');
INSERT INTO extra(name, description) VALUES ('Climatizador', 'Climatizador flamante ...');
INSERT INTO extra(name, description) VALUES ('Wifi', 'Wifi flamante ...');
INSERT INTO extra(name, description) VALUES ('Frigorifico', 'Wifi flamante ...');

-- Ford Mondeo Basic techo solar
INSERT INTO extra_version VALUES (1, 1, 3000); -- Así insertamos en todas las columnas
-- Ford Mondeo Basic Climatizador
INSERT INTO extra_version VALUES (1, 2, 1000);
-- Ford Mondeo Basic Wifi
INSERT INTO extra_version VALUES (1, 3, 500);

-- Ford Mondeo Adavance techo solar
INSERT INTO extra_version VALUES (3, 1, 3300); -- Así insertamos en todas las columnas
-- Ford Mondeo Adavance Climatizador
INSERT INTO extra_version VALUES (3, 2, 1200);
-- Ford Mondeo Adavance Wifi
INSERT INTO extra_version VALUES (3, 3, 500);

CREATE TABLE IF NOT EXISTS employee(
	id SERIAL,
	name VARCHAR(30),
	nif VARCHAR(9) NOT NULL UNIQUE,
	phone VARCHAR(9),
	CONSTRAINT pk_employee PRIMARY KEY(id)
);

INSERT INTO employee(name, nif, phone) VALUES('Ariel', '123456789', '123456789');
INSERT INTO employee(name, nif, phone) VALUES('Bob', '123456909', '123456909');
SELECT * FROM employee;

CREATE TABLE IF NOT EXISTS customer(
	id SERIAL,
	name VARCHAR(30),
	email VARCHAR(50) NOT NULL UNIQUE,
	CONSTRAINT pk_customer PRIMARY KEY(id)
);

INSERT INTO customer(name, email) VALUES('customer1', 'andy@gmail.com');
INSERT INTO customer(name, email) VALUES('customer2', 'toño@gmail.com');
SELECT * FROM customer;

CREATE TABLE IF NOT EXISTS vehicle(
	id SERIAL,
	license_number VARCHAR(7),
	creation_date DATE,
	price_gross NUMERIC,
	price_net NUMERIC,
	type VARCHAR(30),
	
	id_manufacturer INT,
	id_model INT,
	id_version INT,
	id_extra INT,
	
	CONSTRAINT pk_vehicle PRIMARY KEY(id),
	CONSTRAINT fk_vehicle_manufacturer FOREIGN KEY (id_manufacturer) REFERENCES manufacturer(id),
	CONSTRAINT fk_vehicle_model FOREIGN KEY (id_model) REFERENCES model(id),
	CONSTRAINT fk_vehicle_extra_version FOREIGN KEY (id_version, id_extra) REFERENCES extra_version(id_version, id_extra)
);
SELECT * FROM vehicle;

INSERT INTO vehicle(license_number, price_gross, id_manufacturer, id_model, id_version, id_extra)
VALUES('1234lll', 40000, 1, 2, 1, 2);

INSERT INTO vehicle(license_number, price_gross, id_manufacturer, id_model, id_version, id_extra)
VALUES('1254Ull', 60000, 1, 3, 3, 3);

CREATE TABLE IF NOT EXISTS sale(
	id SERIAL,
	sale_date DATE,
	channel VARCHAR(300),
	
	id_vehicle INT,
	id_employee INT,
	id_customer INT,
	
	CONSTRAINT pk_sale PRIMARY KEY(id),
	CONSTRAINT fk_sale_vehicle FOREIGN KEY (id_vehicle) REFERENCES vehicle(id),
	CONSTRAINT fk_employee FOREIGN KEY (id_employee) REFERENCES employee(id),
	CONSTRAINT fk_customer FOREIGN KEY (id_customer) REFERENCES customer(id)
);

INSERT INTO sale(sale_date, channel, id_vehicle, id_employee, id_customer) VALUES('2022-01-01', 'phone', 1, 3, 1);

SELECT * FROM sale;







