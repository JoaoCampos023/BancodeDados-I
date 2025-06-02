USE Formulario_De_Cliente;

-- View: Situação atual dos clientes
CREATE VIEW vw_situacao_atual AS
SELECT 
    c.matricula,
    c.nome AS cliente,
    cg.nome AS cargo,
    d.nome AS departamento,
    sa.data_inicio,
    sa.salario,
    c.telefone,
    c.email
FROM situacao_atual sa
JOIN clientes c ON sa.cliente_id = c.id
JOIN cargos cg ON sa.cargo_id = cg.id
JOIN departamentos d ON sa.departamento_id = d.id;

-- View: Histórico profissional completo
CREATE VIEW vw_historico_profissional AS
SELECT 
    c.matricula,
    c.nome AS cliente,
    cg.nome AS cargo,
    d.nome AS departamento,
    hp.data_inicio,
    hp.data_fim,
    hp.salario,
    CASE WHEN hp.is_atual THEN 'Atual' ELSE 'Histórico' END AS status
FROM historico_profissional hp
JOIN clientes c ON hp.cliente_id = c.id
JOIN cargos cg ON hp.cargo_id = cg.id
LEFT JOIN departamentos d ON hp.departamento_id = d.id
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
    IN p_novo_cargo_id INT,
    IN p_novo_departamento_id INT,
    IN p_data_mudanca DATE,
    IN p_novo_salario DECIMAL(10,2),
    IN p_motivo_saida VARCHAR(255))
BEGIN
    DECLARE v_ultimo_cargo_id INT;
    DECLARE v_ultimo_departamento_id INT;
    
    -- Obter cargo atual
    SELECT cargo_id, departamento_id INTO v_ultimo_cargo_id, v_ultimo_departamento_id
    FROM situacao_atual
    WHERE cliente_id = p_cliente_id;
    
    -- Atualizar histórico: marcar cargo anterior como não atual e definir data_fim
    UPDATE historico_profissional
    SET is_atual = FALSE,
        data_fim = p_data_mudanca,
        motivo_saida = p_motivo_saida
    WHERE cliente_id = p_cliente_id AND is_atual = TRUE;
    
    -- Inserir novo cargo no histórico
    INSERT INTO historico_profissional (cliente_id, cargo_id, departamento_id, data_inicio, is_atual, salario)
    VALUES (p_cliente_id, p_novo_cargo_id, p_novo_departamento_id, p_data_mudanca, TRUE, p_novo_salario);
    
    -- Atualizar situação atual
    UPDATE situacao_atual
    SET cargo_id = p_novo_cargo_id,
        departamento_id = p_novo_departamento_id,
        data_inicio = p_data_mudanca,
        salario = p_novo_salario
    WHERE cliente_id = p_cliente_id;
END //
DELIMITER ;

-- Trigger para manter a consistência da situação atual
DELIMITER //
CREATE TRIGGER trg_after_historico_insert
AFTER INSERT ON historico_profissional
FOR EACH ROW
BEGIN
    IF NEW.is_atual = TRUE THEN
        -- Atualiza ou insere na tabela situacao_atual
        INSERT INTO situacao_atual (cliente_id, cargo_id, departamento_id, data_inicio, salario)
        VALUES (NEW.cliente_id, NEW.cargo_id, NEW.departamento_id, NEW.data_inicio, NEW.salario)
        ON DUPLICATE KEY UPDATE
            cargo_id = NEW.cargo_id,
            departamento_id = NEW.departamento_id,
            data_inicio = NEW.data_inicio,
            salario = NEW.salario;
    END IF;
END //
DELIMITER ;


-- Consulta simples usando a view
SELECT * FROM vw_situacao_atual;
SELECT * FROM vw_historico_profissional;
SELECT * FROM vw_dependentes;

-- Consulta do banco

SELECT * FROM clientes ORDER BY nome;
SELECT * FROM departamentos ORDER BY nome;

SELECT 
    c.id,
    c.nome AS cargo,
    d.nome AS departamento,
    c.nivel,
    c.descricao
FROM cargos c
JOIN departamentos d ON c.departamento_id = d.id
ORDER BY d.nome, c.nome;

SELECT 
    c.matricula,
    c.nome AS cliente,
    cg.nome AS cargo,
    d.nome AS departamento,
    hp.data_inicio,
    hp.data_fim,
    hp.salario,
    hp.motivo_saida,
    CASE WHEN hp.is_atual THEN 'Sim' ELSE 'Não' END AS cargo_atual
FROM historico_profissional hp
JOIN clientes c ON hp.cliente_id = c.id
JOIN cargos cg ON hp.cargo_id = cg.id
LEFT JOIN departamentos d ON hp.departamento_id = d.id
ORDER BY c.nome, hp.data_inicio DESC;

SELECT 
    c.matricula,
    c.nome AS cliente,
    cg.nome AS cargo,
    d.nome AS departamento,
    sa.data_inicio,
    sa.salario,
    sa.ultima_atualizacao
FROM situacao_atual sa
JOIN clientes c ON sa.cliente_id = c.id
JOIN cargos cg ON sa.cargo_id = cg.id
JOIN departamentos d ON sa.departamento_id = d.id
ORDER BY c.nome;

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

SELECT * FROM graus_parentesco ORDER BY descricao;