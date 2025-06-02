CREATE DATABASE IF NOT EXISTS veterinary;

USE veterinary;

CREATE TABLE IF NOT EXISTS animal_type (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    specie VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS animal(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    animal_name VARCHAR(255) NOT NULL,
    birthdate DATETIME NOT NULL,
    color VARCHAR(50) NOT NULL,
    weight FLOAT NOT NULL,
    height INT NOT NULL,
    animal_type_id  INT NOT NULL,
    CONSTRAINT fk_animal_type FOREIGN KEY (animal_type_id) REFERENCES animal_type(id)
);

CREATE TABLE IF NOT EXISTS vaccine(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    vaccine_name VARCHAR(255) NOT NULL,
    vaccine_date DATETIME NOT NULL,
    animal_id INT NOT NULL,
    CONSTRAINT fk_vaccine_animal FOREIGN KEY (id) REFERENCES animal(id)
);


INSERT INTO animal_type (specie) VALUES ('Canine');
INSERT INTO animal_type (specie) VALUES ('Feline');
INSERT INTO animal_type (specie) VALUES ('Swine'); -- Suino
INSERT INTO animal_type (specie) VALUES ('Caprine');
INSERT INTO animal_type (specie) VALUES ('Equine');
INSERT INTO animal_type (specie) VALUES ('Bovine');
INSERT INTO animal_type (specie) VALUES ('Ovine');
INSERT INTO animal_type (specie) VALUES ('Rodent'); -- Roedor  
INSERT INTO ANIMAL_TYPE (SPECIE) VALUES ('Avian'); -- Ave  
INSERT INTO animal_type (specie) VALUES ('Reptile');
INSERT INTO animal_type (specie) VALUES ('Lagomorph'); -- Lagomorfo (coelhos e lebres)  
INSERT INTO animal_type (specie) VALUES ('Amphibian');
INSERT INTO animal_type (specie) VALUES ('Fish');
INSERT INTO animal_type (specie) VALUES ('Exotic');
INSERT INTO animal_type (specie) VALUES ('Wildlife');

SELECT * FROM animal_type;

INSERT INTO animal (animal_name, birthdate, color, weight, height, animal_type_id) VALUES 
('Rex', '2018-03-15 10:30:00', 'Brown', 30.5, 70, 1),
('Mia', '2020-06-22 09:00:00', 'Gray', 8.2, 35, 2),
('Pipoca', '2019-01-05 14:15:00', 'Black', 90.0, 180, 3),
('Bingo', '2021-11-30 11:45:00', 'Golden', 22.0, 65, 1),
('Luna', '2022-02-14 16:00:00', 'White', 5.5, 25, 2),
('Pérola', '2018-08-11 08:00:00', 'Pink', 70.0, 150, 4),
('Thunder', '2017-05-20 13:00:00', 'Chestnut', 500.0, 170, 5),
('Simba', '2020-04-17 07:30:00', 'Orange', 4.8, 40, 2),
('Lulu', '2021-09-03 10:10:00', 'Brown', 15.0, 45, 1),
('Zeca', '2019-11-18 19:00:00', 'Black and White', 75.0, 160, 3),
('Bolt', '2016-12-10 08:20:00', 'Black', 550.0, 175, 5),
('Margarida', '2015-07-25 14:50:00', 'White', 650.0, 150, 6),
('Tigrão', '2019-02-28 12:40:00', 'Striped', 250.0, 90, 6),
('Cacau', '2022-06-09 17:30:00', 'Brown', 2.1, 20, 7),
('Toby', '2023-01-15 11:20:00', 'White', 3.8, 22, 7),
('Blue', '2021-04-05 06:40:00', 'Blue and Yellow', 0.9, 30, 8),
('Gaia', '2020-09-15 09:00:00', 'Green', 0.5, 25, 8),
('Spike', '2018-11-22 15:10:00', 'Dark Green', 5.0, 50, 9),
('Jade', '2019-03-30 20:00:00', 'Light Green', 1.2, 35, 9),
('Aquiles', '2021-05-07 12:20:00', 'Golden', 0.3, 15, 10),
('Brisa', '2020-07-12 14:10:00', 'Silver', 0.2, 12, 10),
('Apollo', '2016-03-09 07:45:00', 'Brown', 700.0, 160, 6),
('Felix', '2021-12-18 16:30:00', 'Gray', 6.0, 37, 2),
('Pingo', '2019-05-27 09:10:00', 'White and Brown', 80.0, 155, 3),
('Caramelo', '2018-10-21 10:00:00', 'Golden', 28.0, 68, 1),
('Nina', '2022-01-30 18:50:00', 'White', 4.2, 30, 2),
('Thor', '2015-06-15 11:25:00', 'Dark Brown', 450.0, 175, 5),
('Chico', '2019-09-10 13:40:00', 'Red', 2.5, 22, 7),
('Oliver', '2023-02-05 06:55:00', 'Blue', 1.0, 18, 8),
('Milu', '2020-11-08 17:20:00', 'Beige', 9.5, 40, 1),
('Max', '2020-04-12 14:30:00', 'Black', 30.0, 70, 1),
('Luna', '2019-07-22 08:45:00', 'Gray', 8.5, 32, 2),
('Toby', '2018-11-05 16:10:00', 'Brown', 90.0, 180, 3),
('Bella', '2021-01-17 10:00:00', 'Golden', 22.5, 60, 1),
('Oscar', '2020-10-15 17:20:00', 'Orange', 4.0, 40, 2),
('Duke', '2022-03-30 11:00:00', 'Chestnut', 550.0, 175, 5),
('Mimi', '2019-08-18 13:30:00', 'White', 7.2, 38, 2),
('Zorro', '2020-02-02 12:50:00', 'Black and White', 75.0, 155, 3),
('Sasha', '2021-12-10 18:00:00', 'Silver', 3.5, 25, 2),
('Canelo', '2017-06-25 14:30:00', 'Brown', 40.0, 65, 1),
('Apolo', '2020-07-22 09:15:00', 'Black and White', 27.3, 66, 10),
('Fiona', '2019-05-10 14:45:00', 'Golden', 31.2, 73, 11),
('Bolt', '2017-12-01 08:10:00', 'Gray', 29.5, 68, 12),
('Maggie', '2021-09-30 11:50:00', 'Brown', 22.8, 59, 13),
('Zelda', '2016-06-18 17:05:00', 'White', 26.0, 65, 14),
('Oscar', '2015-03-27 06:25:00', 'Black', 34.7, 74, 15),
('Toby', '2020-11-12 19:20:00', 'Golden', 23.9, 62, 10),
('Lola', '2018-02-14 12:40:00', 'White and Gray', 28.6, 71, 11),
('Rocky', '2019-10-05 15:55:00', 'Dark Brown', 25.4, 64, 12),
('Kira', '2022-01-25 07:35:00', 'Cream', 21.7, 58, 13);

SELECT * FROM animal;

INSERT INTO vaccine (vaccine_name, vaccine_date, animal_id) VALUES
('Masticine', '2025-03-18 10:00:00', 5), -- Mastite
('Remobac', '2025-03-19 11:30:00', 3), -- Infeccao respiratoria
('Silverbac', '2025-03-21 14:00:00', 6), -- Imunizacao clostridioses
('Rabigen', '2025-03-22 09:00:00', 5),  -- Raiva
('LeptoGuard', '2025-03-23 10:15:00', 6),  -- Leptospirose
('Euryworm', '2025-03-24 11:00:00', 7),  -- Vermifugo
('Feligen', '2025-03-25 08:30:00', 8),  -- V4/V5 para felinos
('PneumoGuard', '2025-03-26 13:00:00', 9),  -- Pneumonia bovina
('Parvovac', '2025-03-27 15:30:00', 10),  -- Parvovirose canina
('TetraEqui', '2025-03-28 16:45:00', 11),  -- Tetano e Influenza equina
('ClostriShield', '2025-03-29 09:30:00', 12),  -- Clostridioses
('MyxoProtect', '2025-03-30 17:00:00', 13),  -- Mixomatose (coelhos)
('SalmoVet', '2025-03-31 18:15:00', 14);  -- Salmonelose (aves)

SELECT * FROM vaccine;

/*
UPDATE animal_type
SET specie = 'Fish'
WHERE ID = 6;
*/

-- Nao permite deletar
/*
DELETE FROM animal
WHERE animal_name  = 'Rex';
*/

/*
DELETE FROM animal_type
WHERE id = 2;
*/