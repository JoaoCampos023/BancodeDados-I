USE Formulario_De_Cliente;

-- View: Situação atual dos clientes
CREATE VIEW vw_situacao_atual AS
SELECT 
    c.matricula,
    c.nome AS cliente,
    cg.nome AS cargo_geral,
    d.nome AS departamento,
    cd.descricao AS cargo_departamento,
    hp.data_inicio,
    hp.salario,
    c.telefone,
    c.email
FROM historico_profissional hp
JOIN clientes c ON hp.cliente_id = c.id
JOIN cargos_departamentos cd ON hp.cargo_departamento_id = cd.id
JOIN cargos_gerais cg ON cd.cargo_geral_id = cg.id
JOIN departamentos d ON cd.departamento_id = d.id
WHERE hp.is_atual = TRUE;

-- View: Histórico profissional completo
CREATE VIEW vw_historico_profissional AS
SELECT 
    c.matricula,
    c.nome AS cliente,
    cg.nome AS cargo_geral,
    d.nome AS departamento,
    cd.descricao AS cargo_departamento,
    hp.data_inicio,
    hp.data_fim,
    hp.salario,
    CASE WHEN hp.is_atual THEN 'Atual' ELSE 'Histórico' END AS status
FROM historico_profissional hp
JOIN clientes c ON hp.cliente_id = c.id
JOIN cargos_departamentos cd ON hp.cargo_departamento_id = cd.id
JOIN cargos_gerais cg ON cd.cargo_geral_id = cg.id
JOIN departamentos d ON cd.departamento_id = d.id
ORDER BY c.nome, hp.data_inicio DESC;

-- View: Dependentes dos clientes
CREATE VIEW vw_dependentes AS
SELECT 
    c.matricula,
    c.nome AS cliente,
    d.nome AS dependente,
    d.data_nascimento,
    gp.descricao AS grau_parentesco,
    TIMESTAMPDIFF(YEAR, d.data_nascimento, CURDATE()) AS idade
FROM dependentes d
JOIN clientes c ON d.cliente_id = c.id
LEFT JOIN graus_parentesco gp ON d.grau_parentesco_id = gp.id
ORDER BY c.nome, d.data_nascimento;

-- Stored Procedure para atualização de cargo
DELIMITER //
CREATE PROCEDURE sp_atualizar_cargo(
    IN p_cliente_id INT,
    IN p_novo_cargo_departamento_id INT,
    IN p_data_mudanca DATE,
    IN p_novo_salario DECIMAL(10,2),
    IN p_motivo_saida VARCHAR(255))
BEGIN
    -- Atualizar histórico: marcar cargo anterior como não atual e definir data_fim
    UPDATE historico_profissional
    SET is_atual = FALSE,
        data_fim = p_data_mudanca,
        motivo_saida = p_motivo_saida
    WHERE cliente_id = p_cliente_id AND is_atual = TRUE;
    
    -- Inserir novo cargo no histórico
    INSERT INTO historico_profissional (cliente_id, cargo_departamento_id, data_inicio, is_atual, salario)
    VALUES (p_cliente_id, p_novo_cargo_departamento_id, p_data_mudanca, TRUE, p_novo_salario);
END //
DELIMITER ;

-- Trigger para garantir apenas um cargo atual por cliente
DELIMITER //
CREATE TRIGGER trg_before_historico_insert
BEFORE INSERT ON historico_profissional
FOR EACH ROW
BEGIN
    IF NEW.is_atual = TRUE THEN
        -- Verificar se já existe um cargo atual para o cliente
        IF EXISTS (SELECT 1 FROM historico_profissional WHERE cliente_id = NEW.cliente_id AND is_atual = TRUE) THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Já existe um cargo atual para este cliente. Atualize o cargo anterior primeiro.';
        END IF;
    END IF;
END //
DELIMITER ;