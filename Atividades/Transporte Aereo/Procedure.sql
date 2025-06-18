USE Aeroporto;

-- Procedure para reservar uma poltrona
DELIMITER //
CREATE PROCEDURE reservar_poltrona(
    IN p_id_cliente INT,
    IN p_id_voo INT,
    IN p_numero_poltrona VARCHAR(10),
    IN p_forma_pagamento ENUM('Cartão Crédito', 'Cartão Débito', 'Boleto', 'Transferência', 'Milhas')
)
BEGIN
    DECLARE v_id_poltrona INT;
    DECLARE v_id_config INT;
    DECLARE v_id_classe INT;
    DECLARE v_preco_base DECIMAL(10,2);
    DECLARE v_multiplicador DECIMAL(3,2);
    DECLARE v_preco_final DECIMAL(10,2);
    DECLARE v_disponivel BOOLEAN;
    
    -- Encontrar a poltrona
    SELECT p.id_poltrona, p.id_classe INTO v_id_poltrona, v_id_classe
    FROM poltronas p
    JOIN aeronaves a ON p.id_aeronave = a.id_aeronave
    JOIN voos v ON v.id_aeronave = a.id_aeronave
    WHERE v.id_voo = p_id_voo AND p.numero_poltrona = p_numero_poltrona;
    
    -- Verificar se a poltrona existe
    IF v_id_poltrona IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Poltrona não encontrada para este voo';
    END IF;
    
    -- Encontrar a configuração da poltrona no voo
    SELECT id_config, disponivel INTO v_id_config, v_disponivel
    FROM config_poltronas_voo
    WHERE id_voo = p_id_voo AND id_poltrona = v_id_poltrona;
    
    -- Verificar disponibilidade
    IF NOT v_disponivel THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Poltrona já ocupada';
    END IF;
    
    -- Obter preço base e multiplicador da classe
    SELECT 1000.00, multiplicador_preco INTO v_preco_base, v_multiplicador
    FROM classes WHERE id_classe = v_id_classe;
    
    -- Calcular preço final
    SET v_preco_final = v_preco_base * v_multiplicador;
    
    -- Aplicar desconto para clientes Diamante
    IF EXISTS (SELECT 1 FROM clientes WHERE id_cliente = p_id_cliente AND nivel_preferencia = 'Diamante') THEN
        SET v_preco_final = v_preco_final * 0.9; -- 10% de desconto
    END IF;
    
    -- Criar a reserva
    INSERT INTO reservas (id_cliente, id_config, status, forma_pagamento, valor_total, preco_poltrona)
    VALUES (p_id_cliente, v_id_config, 'Confirmada', p_forma_pagamento, v_preco_final, v_preco_final);
    
    -- Atualizar disponibilidade da poltrona
    UPDATE config_poltronas_voo SET disponivel = FALSE WHERE id_config = v_id_config;
    
    -- Atualizar milhas do cliente (se pagou com dinheiro)
    IF p_forma_pagamento != 'Milhas' THEN
        UPDATE clientes 
        SET milhas_accumuladas = milhas_accumuladas + (v_preco_final * 0.1) -- 10% do valor em milhas
        WHERE id_cliente = p_id_cliente;
    END IF;
    
    SELECT 'Reserva realizada com sucesso' AS mensagem, v_preco_final AS valor_pago;
END //
DELIMITER ;

-- Procedure para atualizar status de voo
DELIMITER //
CREATE PROCEDURE atualizar_status_voo(
    IN p_id_voo INT,
    IN p_novo_status ENUM('Agendado', 'Embarque', 'Decolado', 'Aterrissado', 'Cancelado', 'Atrasado'),
    IN p_horario_saida_real DATETIME,
    IN p_horario_chegada_real DATETIME,
    IN p_tempo_atraso INT,
    IN p_motivo_atraso TEXT
)
BEGIN
    -- Atualizar status do voo
    UPDATE voos 
    SET status = p_novo_status 
    WHERE id_voo = p_id_voo;
    
    -- Se o voo foi concluído, registrar no histórico
    IF p_novo_status = 'Aterrissado' OR p_novo_status = 'Cancelado' THEN
        INSERT INTO historico_voos (id_voo, horario_saida_real, horario_chegada_real, tempo_atraso, motivo_atraso)
        VALUES (p_id_voo, p_horario_saida_real, p_horario_chegada_real, p_tempo_atraso, p_motivo_atraso);
        
        -- Atualizar dados dos clientes que estavam nesse voo
        UPDATE clientes c
        JOIN reservas r ON c.id_cliente = r.id_cliente
        JOIN config_poltronas_voo cpv ON r.id_config = cpv.id_config
        SET 
            c.data_ultimo_voo = CURRENT_DATE(),
            c.frequencia_voos_ano = c.frequencia_voos_ano + 1
        WHERE cpv.id_voo = p_id_voo AND r.status = 'Check-in realizado';
    END IF;
    
    SELECT CONCAT('Status do voo ', p_id_voo, ' atualizado para ', p_novo_status) AS mensagem;
END //
DELIMITER ;

-- Procedure para promover clientes com base em milhas
DELIMITER //
CREATE PROCEDURE promover_clientes()
BEGIN
    -- Promover para Diamante (30.000+ milhas)
    UPDATE clientes 
    SET nivel_preferencia = 'Diamante'
    WHERE milhas_accumuladas >= 30000 AND nivel_preferencia != 'Diamante';
    
    -- Promover para Ouro (15.000+ milhas)
    UPDATE clientes 
    SET nivel_preferencia = 'Ouro'
    WHERE milhas_accumuladas >= 15000 AND milhas_accumuladas < 30000 
    AND nivel_preferencia NOT IN ('Diamante', 'Ouro');
    
    -- Promover para Prata (7.500+ milhas)
    UPDATE clientes 
    SET nivel_preferencia = 'Prata'
    WHERE milhas_accumuladas >= 7500 AND milhas_accumuladas < 15000 
    AND nivel_preferencia NOT IN ('Diamante', 'Ouro', 'Prata');
    
    SELECT CONCAT(ROW_COUNT(), ' clientes promovidos') AS resultado;
END //
DELIMITER ;