CREATE DATABASE realestate;

USE realestate;

CREATE TABLE IF NOT EXISTS  property(
	id INT NOT NULL AUTO_INCREMENT,
    property_name CHAR(50) NOT NULL,
    property_description TINYTEXT NOT NULL ,
    n_rooms INT NOT NULL,
    sale_value FLOAT NOT NULL,
    PRIMARY KEY pk_property (id)
);

SELECT * FROM property;

INSERT INTO property (property_name, property_description, n_rooms, sale_value) VALUES 
('Novelo Building', 'A beautiful building', 5, 500000.00),
('Green Building', 'An eco-friendly building with solar energy', 4, 450000.00),
('Sunrise Residential', 'Condominium with complete leisure area', 3, 350000.00),
('Lake House', 'Beautiful house by the lake', 6, 750000.00),
('Downtown Apartment', 'Modern apartment in the city center', 2, 300000.00),
('Dream Ranch', 'Ranch with ample green space', 5, 600000.00),
('Garden Building', 'Building with park view', 4, 550000.00),
('Beach House', 'Vacation home just steps from the beach', 3, 400000.00),
('Urban Loft', 'Modern loft in revitalized area', 1, 250000.00),
('Wind Mansion', 'Luxury mansion with pool and garden', 8, 2000000.00);

SELECT * FROM property;

SELECT * FROM property WHERE sale_value < 500000 AND n_rooms > 2;

SELECT * FROM property WHERE n_rooms > 5;

-- % indica que tem coisas antes e depois
SELECT * FROM property WHERE sale_value >= 500000 AND property_name LIKE '%Building%';