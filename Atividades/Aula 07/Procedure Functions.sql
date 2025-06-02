USE nota_fiscal_normalizada;

SELECT * FROM nota_fiscal_normalizada.nota_fiscal;

CREATE FUNCTION hello(s CHAR(20))
	RETURNS CHAR(50) DETERMINISTIC 
    RETURN CONCAT('Olá, ', s, '!') 
    
SELECT Hello('Joao');

SELECT hello(DESC_PRODUTO) 
FROM nota_fiscal_normalizada.PRODUTO 
WHERE COD_PRODUTO = 4;