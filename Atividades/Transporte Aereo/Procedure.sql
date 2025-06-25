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

-- Procedure para check-in de passageiros
DELIMITER //
CREATE PROCEDURE realizar_checkin(
    IN p_id_reserva INT,
    IN p_numero_bagagens INT
)
BEGIN
    DECLARE v_id_voo INT;
    DECLARE v_id_cliente INT;
    DECLARE v_nivel_cliente ENUM('Bronze', 'Prata', 'Ouro', 'Diamante');
    
    -- Verificar se a reserva existe e está confirmada
    IF NOT EXISTS (SELECT 1 FROM reservas WHERE id_reserva = p_id_reserva AND status = 'Confirmada') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Reserva não encontrada ou não confirmada';
    END IF;
    
    -- Obter informações do voo e cliente
    SELECT cpv.id_voo, r.id_cliente, c.nivel_preferencia 
    INTO v_id_voo, v_id_cliente, v_nivel_cliente
    FROM reservas r
    JOIN config_poltronas_voo cpv ON r.id_config = cpv.id_config
    JOIN clientes c ON r.id_cliente = c.id_cliente
    WHERE r.id_reserva = p_id_reserva;
    
    -- Verificar limite de bagagens
    IF p_numero_bagagens > 
        CASE v_nivel_cliente
            WHEN 'Diamante' THEN 3
            WHEN 'Ouro' THEN 2
            WHEN 'Prata' THEN 1
            ELSE 1
        END THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Número de bagagens excede o permitido para seu nível';
    END IF;
    
    -- Atualizar status da reserva
    UPDATE reservas SET status = 'Check-in realizado' WHERE id_reserva = p_id_reserva;
    
    -- Registrar bagagens (se necessário)
    -- (Aqui poderia inserir em uma tabela de bagagens)
    
    SELECT CONCAT('Check-in realizado com sucesso para a reserva ', p_id_reserva) AS mensagem;
END //
DELIMITER ;

-- Procedure para cancelamento de voo com reembolso automático
DELIMITER //
CREATE PROCEDURE cancelar_voo_com_reembolso(
    IN p_id_voo INT,
    IN p_motivo TEXT
)
BEGIN
    DECLARE v_count INT;
    
    -- Verificar se o voo existe e está agendado
    SELECT COUNT(*) INTO v_count FROM voos 
    WHERE id_voo = p_id_voo AND status = 'Agendado';
    
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Voo não encontrado ou já cancelado/concluído';
    END IF;
    
    -- Atualizar status do voo
    UPDATE voos SET status = 'Cancelado' WHERE id_voo = p_id_voo;
    
    -- Registrar no histórico
    INSERT INTO historico_voos (id_voo, horario_saida_real, horario_chegada_real, motivo_atraso)
    VALUES (p_id_voo, NULL, NULL, p_motivo);
    
    -- Processar reembolsos para todas as reservas
    UPDATE reservas r
    JOIN config_poltronas_voo cpv ON r.id_config = cpv.id_config
    SET 
        r.status = 'Cancelada',
        -- Registrar reembolso (na prática, aqui seria integrado com um sistema de pagamento)
        r.valor_total = 0
    WHERE 
        cpv.id_voo = p_id_voo 
        AND r.status IN ('Confirmada', 'Em espera', 'Check-in realizado');
    
    SELECT CONCAT('Voo ', p_id_voo, ' cancelado. ', ROW_COUNT(), ' reservas afetadas.') AS mensagem;
END //
DELIMITER ;

-- Procedure para upgrade de classe com custo adicional
DELIMITER //
CREATE PROCEDURE upgrade_classe(
    IN p_id_reserva INT,
    IN p_nova_classe INT
)
BEGIN
    DECLARE v_id_cliente INT;
    DECLARE v_id_voo INT;
    DECLARE v_id_poltrona_antiga INT;
    DECLARE v_id_classe_antiga INT;
    DECLARE v_preco_antigo DECIMAL(10,2);
    DECLARE v_multiplicador_novo DECIMAL(3,2);
    DECLARE v_preco_novo DECIMAL(10,2);
    DECLARE v_diferenca DECIMAL(10,2);
    DECLARE v_poltronas_disponiveis INT;
    DECLARE v_nivel_cliente ENUM('Bronze', 'Prata', 'Ouro', 'Diamante');
    
    -- Obter informações da reserva atual
    SELECT 
        r.id_cliente, cpv.id_voo, cpv.id_poltrona, p.id_classe, r.valor_total,
        c.nivel_preferencia
    INTO 
        v_id_cliente, v_id_voo, v_id_poltrona_antiga, v_id_classe_antiga, v_preco_antigo,
        v_nivel_cliente
    FROM reservas r
    JOIN config_poltronas_voo cpv ON r.id_config = cpv.id_config
    JOIN poltronas p ON cpv.id_poltrona = p.id_poltrona
    JOIN clientes c ON r.id_cliente = c.id_cliente
    WHERE r.id_reserva = p_id_reserva;
    
    -- Verificar se a reserva existe e está confirmada
    IF v_id_cliente IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Reserva não encontrada';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM reservas WHERE id_reserva = p_id_reserva AND status = 'Confirmada') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Apenas reservas confirmadas podem ser alteradas';
    END IF;
    
    -- Verificar se a nova classe é diferente e superior
    IF p_nova_classe <= v_id_classe_antiga THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A nova classe deve ser superior à atual';
    END IF;
    
    -- Obter multiplicador da nova classe
    SELECT multiplicador_preco INTO v_multiplicador_novo
    FROM classes WHERE id_classe = p_nova_classe;
    
    -- Calcular novo preço (base 1000 * multiplicador)
    SET v_preco_novo = 1000.00 * v_multiplicador_novo;
    
    -- Aplicar desconto para clientes Diamante
    IF v_nivel_cliente = 'Diamante' THEN
        SET v_preco_novo = v_preco_novo * 0.9; -- 10% de desconto
    END IF;
    
    -- Calcular diferença a pagar
    SET v_diferenca = v_preco_novo - v_preco_antigo;
    
    -- Verificar se há poltronas disponíveis na nova classe
    SELECT COUNT(*) INTO v_poltronas_disponiveis
    FROM config_poltronas_voo cpv
    JOIN poltronas p ON cpv.id_poltrona = p.id_poltrona
    WHERE cpv.id_voo = v_id_voo 
    AND p.id_classe = p_nova_classe
    AND cpv.disponivel = TRUE;
    
    IF v_poltronas_disponiveis = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não há poltronas disponíveis na classe selecionada';
    END IF;
    
    -- Encontrar uma poltrona disponível na nova classe
    SET @nova_poltrona_id = (
        SELECT cpv.id_config
        FROM config_poltronas_voo cpv
        JOIN poltronas p ON cpv.id_poltrona = p.id_poltrona
        WHERE cpv.id_voo = v_id_voo 
        AND p.id_classe = p_nova_classe
        AND cpv.disponivel = TRUE
        LIMIT 1
    );
    
    -- Liberar poltrona antiga
    UPDATE config_poltronas_voo SET disponivel = TRUE 
    WHERE id_poltrona = v_id_poltrona_antiga AND id_voo = v_id_voo;
    
    -- Ocupar nova poltrona
    UPDATE config_poltronas_voo SET disponivel = FALSE 
    WHERE id_config = @nova_poltrona_id;
    
    -- Atualizar reserva
    UPDATE reservas 
    SET 
        id_config = @nova_poltrona_id,
        valor_total = v_preco_novo,
        preco_poltrona = v_preco_novo
    WHERE id_reserva = p_id_reserva;
    
    SELECT 
        'Upgrade realizado com sucesso' AS mensagem,
        v_diferenca AS valor_adicional,
        v_preco_novo AS novo_valor_total;
END //
DELIMITER ;

-- Procedure para gerar relatório de ocupação por período
DELIMITER //
CREATE PROCEDURE relatorio_ocupacao_periodo(
    IN p_data_inicio DATE,
    IN p_data_fim DATE
)
BEGIN
    SELECT 
        v.id_voo,
        v.numero_voo,
        a.modelo AS aeronave,
        ao.nome AS origem,
        ad.nome AS destino,
        v.horario_saida,
        COUNT(r.id_reserva) AS poltronas_vendidas,
        a.numero_poltronas AS capacidade,
        CONCAT(ROUND((COUNT(r.id_reserva) / a.numero_poltronas) * 100, 2), '%') AS ocupacao,
        SUM(r.valor_total) AS receita_total
    FROM 
        voos v
    JOIN 
        aeronaves a ON v.id_aeronave = a.id_aeronave
    JOIN 
        rotas rt ON v.id_rota = rt.id_rota
    JOIN 
        aeroportos ao ON rt.id_aeroporto_origem = ao.id_aeroporto
    JOIN 
        aeroportos ad ON rt.id_aeroporto_destino = ad.id_aeroporto
    LEFT JOIN 
        config_poltronas_voo cpv ON v.id_voo = cpv.id_voo
    LEFT JOIN 
        reservas r ON cpv.id_config = r.id_config AND r.status != 'Cancelada'
    WHERE 
        DATE(v.horario_saida) BETWEEN p_data_inicio AND p_data_fim
    GROUP BY 
        v.id_voo, v.numero_voo, a.modelo, ao.nome, ad.nome, v.horario_saida, a.numero_poltronas
    ORDER BY 
        ocupacao DESC;
END //
DELIMITER ;