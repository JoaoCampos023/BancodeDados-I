USE Aeroporto;

-- Trigger para atualizar a disponibilidade da poltrona quando uma reserva é cancelada
DELIMITER //
CREATE TRIGGER trg_reserva_cancelada
AFTER UPDATE ON reservas
FOR EACH ROW
BEGIN
    IF NEW.status = 'Cancelada' AND OLD.status != 'Cancelada' THEN
        UPDATE config_poltronas_voo 
        SET disponivel = TRUE 
        WHERE id_config = NEW.id_config;
        
        -- Devolver 80% das milhas se o pagamento foi com milhas
        IF NEW.forma_pagamento = 'Milhas' THEN
            UPDATE clientes
            SET milhas_accumuladas = milhas_accumuladas + (NEW.valor_total * 0.8)
            WHERE id_cliente = NEW.id_cliente;
        END IF;
    END IF;
END //
DELIMITER ;

-- Trigger para verificar se há poltronas disponíveis antes de inserir uma reserva
DELIMITER //
CREATE TRIGGER trg_verificar_disponibilidade
BEFORE INSERT ON reservas
FOR EACH ROW
BEGIN
    DECLARE v_disponivel BOOLEAN;
    
    SELECT disponivel INTO v_disponivel
    FROM config_poltronas_voo
    WHERE id_config = NEW.id_config;
    
    IF NOT v_disponivel THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Poltrona não disponível para reserva';
    END IF;
END //
DELIMITER ;

-- Trigger para registrar alterações no status dos voos
DELIMITER //
CREATE TRIGGER trg_log_status_voo
AFTER UPDATE ON voos
FOR EACH ROW
BEGIN
    IF NEW.status != OLD.status THEN
        INSERT INTO auditoria_voo (id_voo, status_anterior, status_novo, data_alteracao, usuario)
        VALUES (NEW.id_voo, OLD.status, NEW.status, NOW(), CURRENT_USER());
    END IF;
END //
DELIMITER ;

-- Trigger para atualizar milhas quando um voo é concluído
DELIMITER //
CREATE TRIGGER trg_atualizar_milhas_conclusao_voo
AFTER INSERT ON historico_voos
FOR EACH ROW
BEGIN
    -- Atualizar milhas para todos os clientes que voaram
    UPDATE clientes c
    JOIN reservas r ON c.id_cliente = r.id_cliente
    JOIN config_poltronas_voo cpv ON r.id_config = cpv.id_config
    SET 
        c.milhas_accumuladas = c.milhas_accumuladas + 
            CASE 
                WHEN r.forma_pagamento != 'Milhas' THEN r.valor_total * 0.05  -- 5% do valor em milhas extras por voo concluído
                ELSE 0
            END
    WHERE 
        cpv.id_voo = NEW.id_voo 
        AND r.status = 'Check-in realizado';
END //
DELIMITER ;

-- Trigger para verificar idade mínima do cliente
DELIMITER //
CREATE TRIGGER trg_verificar_idade_cliente
BEFORE INSERT ON clientes
FOR EACH ROW
BEGIN
    DECLARE idade INT;
    SET idade = TIMESTAMPDIFF(YEAR, NEW.data_nascimento, CURDATE());
    
    IF idade < 12 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Clientes devem ter pelo menos 12 anos';
    END IF;
END //
DELIMITER ;

-- Trigger para registrar alterações em reservas
DELIMITER //
CREATE TRIGGER trg_log_alteracoes_reserva
AFTER UPDATE ON reservas
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status OR OLD.valor_total != NEW.valor_total THEN
        INSERT INTO auditoria_reservas (id_reserva, status_anterior, status_novo, valor_anterior, valor_novo, data_alteracao, usuario)
        VALUES (NEW.id_reserva, OLD.status, NEW.status, OLD.valor_total, NEW.valor_total, NOW(), CURRENT_USER());
    END IF;
END //
DELIMITER ;
