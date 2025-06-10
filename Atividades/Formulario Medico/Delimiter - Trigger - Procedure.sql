USE consultorio_medico;

-- Trigger para registrar quando um paciente é desativado de um convênio
DELIMITER //
CREATE TRIGGER trg_paciente_convenio_desativado
BEFORE UPDATE ON paciente_convenio
FOR EACH ROW
BEGIN
    IF NEW.ativo = FALSE AND OLD.ativo = TRUE THEN
        SET NEW.data_fim = CURDATE();
    END IF;
END //
DELIMITER ;

-- Trigger para evitar agendamento de consulta no passado
DELIMITER //
CREATE TRIGGER trg_valida_data_consulta
BEFORE INSERT ON consultas
FOR EACH ROW
BEGIN
    IF NEW.data_consulta < NOW() AND NEW.status = 'Agendada' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Não é possível agendar consulta para data/hora no passado';
    END IF;
END //
DELIMITER ;

-- Trigger para atualizar automaticamente o status do exame quando a data de resultado é inserida
DELIMITER //
CREATE TRIGGER trg_atualiza_status_exame
BEFORE UPDATE ON exames
FOR EACH ROW
BEGIN
    IF NEW.data_resultado IS NOT NULL AND OLD.data_resultado IS NULL THEN
        SET NEW.status = 'Resultado Disponível';
    END IF;
END //
DELIMITER ;

-- Procedure para agendar consulta com validações
DELIMITER //
CREATE PROCEDURE sp_agendar_consulta(
    IN p_id_paciente INT,
    IN p_id_medico INT,
    IN p_data_consulta DATETIME
)
BEGIN
    DECLARE v_medico_disponivel INT;
    
    -- Verifica se o médico está disponível no horário
    SELECT COUNT(*) INTO v_medico_disponivel
    FROM consultas
    WHERE id_medico = p_id_medico
    AND data_consulta = p_data_consulta
    AND status != 'Cancelada';
    
    IF v_medico_disponivel > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Médico já possui consulta agendada neste horário';
    ELSE
        INSERT INTO consultas (id_paciente, id_medico, data_consulta, status)
        VALUES (p_id_paciente, p_id_medico, p_data_consulta, 'Agendada');
    END IF;
END //
DELIMITER ;

-- Procedure para gerar relatório de consultas por período
DELIMITER //
CREATE PROCEDURE sp_relatorio_consultas(
    IN p_data_inicio DATE,
    IN p_data_fim DATE
)
BEGIN
    SELECT 
        c.id_consulta,
        p.nome AS paciente,
        m.nome AS medico,
        e.nome AS especialidade,
        c.data_consulta,
        c.status
    FROM consultas c
    JOIN pacientes p ON c.id_paciente = p.id_paciente
    JOIN medicos m ON c.id_medico = m.id_medico
    JOIN especialidades e ON m.id_especialidade = e.id_especialidade
    WHERE DATE(c.data_consulta) BETWEEN p_data_inicio AND p_data_fim
    ORDER BY c.data_consulta;
END //
DELIMITER ;

-- Procedure para listar exames pendentes de um paciente
DELIMITER //
CREATE PROCEDURE sp_exames_pendentes(
    IN p_id_paciente INT
)
BEGIN
    SELECT 
        e.id_exame,
        te.nome AS tipo_exame,
        e.data_solicitacao,
        e.status,
        CASE 
            WHEN e.data_realizacao IS NULL THEN 'Pendente de realização'
            WHEN e.data_resultado IS NULL THEN 'Pendente de resultado'
            ELSE 'Resultado disponível'
        END AS situacao
    FROM exames e
    JOIN tipos_exame te ON e.id_tipo_exame = te.id_tipo_exame
    WHERE e.id_paciente = p_id_paciente
    AND e.status != 'Cancelado'
    AND (e.data_realizacao IS NULL OR e.data_resultado IS NULL)
    ORDER BY e.data_solicitacao DESC;
END //
DELIMITER ;

-- Consulta 1: Listar todas as consultas com informações completas
SELECT 
    c.id_consulta,
    p.nome AS paciente,
    p.numero_paciente,
    m.nome AS medico,
    e.nome AS especialidade,
    c.data_consulta,
    c.diagnostico,
    c.status
FROM consultas c
JOIN pacientes p ON c.id_paciente = p.id_paciente
JOIN medicos m ON c.id_medico = m.id_medico
JOIN especialidades e ON m.id_especialidade = e.id_especialidade
ORDER BY c.data_consulta DESC;

-- Consulta 2: Listar exames com resultados pendentes
SELECT 
    e.id_exame,
    p.nome AS paciente,
    te.nome AS tipo_exame,
    e.data_solicitacao,
    e.data_realizacao,
    DATEDIFF(CURDATE(), e.data_realizacao) AS dias_esperando_resultado,
    e.status
FROM exames e
JOIN pacientes p ON e.id_paciente = p.id_paciente
JOIN tipos_exame te ON e.id_tipo_exame = te.id_tipo_exame
WHERE e.status != 'Resultado Disponível'
AND e.status != 'Cancelado'
ORDER BY e.data_realizacao;

-- Consulta 3: Listar pacientes e seus convênios ativos
SELECT 
    p.nome AS paciente,
    p.telefone,
    p.email,
    c.nome AS convenio,
    pc.numero_carteira,
    pc.data_inicio
FROM pacientes p
JOIN paciente_convenio pc ON p.id_paciente = pc.id_paciente
JOIN convenios c ON pc.id_convenio = c.id_convenio
WHERE pc.ativo = TRUE
ORDER BY p.nome;

-- Consulta 4: Relatório de consultas por especialidade
SELECT 
    e.nome AS especialidade,
    COUNT(*) AS total_consultas,
    SUM(CASE WHEN c.status = 'Realizada' THEN 1 ELSE 0 END) AS realizadas,
    SUM(CASE WHEN c.status = 'Cancelada' THEN 1 ELSE 0 END) AS canceladas,
    SUM(CASE WHEN c.status = 'Falta' THEN 1 ELSE 0 END) AS faltas
FROM consultas c
JOIN medicos m ON c.id_medico = m.id_medico
JOIN especialidades e ON m.id_especialidade = e.id_especialidade
WHERE DATE(c.data_consulta) BETWEEN '2023-05-01' AND '2023-05-31'
GROUP BY e.nome
ORDER BY total_consultas DESC;

-- Consulta 5: Listar pacientes sem consulta nos últimos 6 meses
SELECT 
    p.id_paciente,
    p.nome,
    p.telefone,
    p.email,
    MAX(c.data_consulta) AS ultima_consulta,
    DATEDIFF(CURDATE(), MAX(c.data_consulta)) AS dias_sem_consulta
FROM pacientes p
LEFT JOIN consultas c ON p.id_paciente = c.id_paciente
GROUP BY p.id_paciente, p.nome, p.telefone, p.email
HAVING ultima_consulta IS NULL OR dias_sem_consulta > 180
ORDER BY dias_sem_consulta DESC;