DELIMITER //
CREATE PROCEDURE GetAllProducts ()
BEGIN
	/* Declaração de variaveis */
	DECLARE totalSale DEC(10,2) default 0.0;
    DECLARE x, y, total, qtd INT DEFAULT 0;
    /*------------------------------ */
    
    
    /* Atribuição de valores */
    SET total = 10;
    
    /* Carregando valores de um select em uma variavel */
    SELECT COUNT(*)
    INTO qtd
    FROM produto;
    
    SELECT qtd;
    
    SELECT * FROM PRODUTO;
    
END//
DELIMITER ;

CALL GetAllProducts();

DELIMITER // 

CREATE PROCEDURE GetProductById(
	IN pProductId INT, 
    OUT pProductLevel VARCHAR (20)
)
BEGIN
	
    DECLARE VALOR DECIMAL (10,2) DEFAULT 0;
    
    SELECT COUNT(*)
    INTO VALOR
    FROM PRODUTO AS P 
    WHERE P.COD_PRODUTO = pProductId;
    
    IF ( VALOR >=5 AND VALOR <= 10) THEN
		SET pProductLevel = 'CRITICO';
	ELSEIF ( VALOR > 10 AND VALOR <= 20 ) THEN
		SET pProductLevel = 'PREOCUPANTE'; 
	ELSEIF (  VALOR > 20) THEN 
		SET pProductLevel = 'TA SUAVE'; 
	ELSE 
		SET pProductLevel = 'FUJA';
	END IF; 
    
END$$
DELIMITER ;
