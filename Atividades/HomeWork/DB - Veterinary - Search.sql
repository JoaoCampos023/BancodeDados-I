USE veterinary;

-- A) Qual a quantidade de animais registradas no sistema?
SELECT 
	COUNT(*) AS animal_count
FROM 
	animal;

-- B) Qual o total de vacinas aplicadas registradas no sistema?
SELECT 
	COUNT(*) AS total_vaccines
FROM 
	vaccine;
    
-- C) Quantos animais temos agrupados registrados para cada categoria?
SELECT  typ.specie, COUNT(an.id) AS total
FROM 
	animal AS an
    INNER JOIN animal_type AS typ ON typ.id = an.animal_type_id
GROUP BY typ.specie
ORDER BY total DESC, typ.specie ASC;
-- Primeiro ordena pelo total, dps pelo nome

-- D) Qual a categoria de animais de mais vacinas recebeu?
SELECT typ.specie, COUNT(va.id) AS num_vaccine
FROM
	animal_type AS typ
    INNER JOIN animal AS an ON an.animal_type_id = typ.id
    INNER JOIN vaccine AS va ON va.animal_id = an.id
GROUP BY typ.specie
ORDER BY num_vaccine DESC;

-- Extra
-- E) Numero de animais vacinados
SELECT 
    COUNT(DISTINCT va.animal_id) AS animals_vaccinated
FROM 
    vaccine AS va
    INNER JOIN animal AS an ON va.animal_id = an.id;

-- F) Retorne o nome do animal mais pesado de cada especie
SELECT tpy.specie, an.animal_name, 
    MAX(an.weight) AS animal_weight
FROM
    animal AS an
    INNER JOIN animal_type AS tpy ON an.animal_type_id = tpy.id
GROUP BY 
    tpy.specie, 
    an.animal_name
ORDER BY 
    animal_weight DESC, 
    tpy.specie ASC, 
    an.animal_name ASC;

-- G) Retorne as 5 primeiras vacinas aplicadas
SELECT va.vaccine_name, tpy.specie, va.vaccine_date
FROM
    vaccine AS va
    INNER JOIN animal AS an ON va.animal_id = an.id
    INNER JOIN animal_type AS tpy ON an.animal_type_id = tpy.id
ORDER BY 
    va.vaccine_date ASC
LIMIT 5;
-- Usando 2 joins porque VACCINE nao possui relacao direta com ANIMAl_TYPE

/*
-- Versao com data formata para estilo brasileiro
SELECT va.vaccine_name, tpy.specie, DATE_FORMAT(va.vaccine_date, '%d/%m/%Y')
FROM
    vaccine AS va
    INNER JOIN animal AS an ON va.animal_id = an.id
    INNER JOIN animal_type AS tpy ON an.animal_type_id = tpy.id
ORDER BY 
    va.vaccine_date ASC
LIMIT 5;
*/

-- H) Retorne a altura media dos felinos
SELECT typ.specie, AVG(an.height) AS avg_height
FROM 
    animal AS an
    INNER JOIN animal_type AS typ ON an.animal_type_id = typ.id
WHERE 
    typ.specie = 'Feline'
GROUP BY 
    typ.specie;

-- I) Retorne a soma do peso dos bovinos
SELECT typ.specie, SUM(an.weight) AS sum_weight
FROM 
    animal AS an
    INNER JOIN animal_type AS typ ON an.animal_type_id = typ.id
WHERE 
    typ.specie = 'Bovine'
GROUP BY 
    typ.specie;

-- J) Retorne todo animal marrom
-- Data em formato americano
SELECT 
    an.animal_name, typ.specie, an.color, 
    an.weight, an.height, DATE_FORMAT(an.birthdate, '%Y-%m-%d') AS formatted_date
FROM 
    animal AS an
    INNER JOIN animal_type AS typ ON an.animal_type_id = typ.id
WHERE 
    an.color = 'Brown'
ORDER BY 
    an.animal_name ASC