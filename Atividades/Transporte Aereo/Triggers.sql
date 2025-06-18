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

-- (Observação: A tabela auditoria_voo precisaria ser criada primeiro)
CREATE TABLE IF NOT EXISTS auditoria_voo (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_voo INT NOT NULL,
    status_anterior ENUM('Agendado', 'Embarque', 'Decolado', 'Aterrissado', 'Cancelado', 'Atrasado'),
    status_novo ENUM('Agendado', 'Embarque', 'Decolado', 'Aterrissado', 'Cancelado', 'Atrasado'),
    data_alteracao DATETIME,
    usuario VARCHAR(50)
);

DROP TABLE auditoria_voo;