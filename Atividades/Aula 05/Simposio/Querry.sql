USE Simposio;

-- Tabelas principais
SELECT * FROM Pessoa;
SELECT * FROM Tema;
SELECT * FROM Comissao;
SELECT * FROM Minicurso;
SELECT * FROM Artigo;
SELECT * FROM Palestra;
SELECT * FROM Simposio;

-- Tabelas relacionamentos
SELECT * FROM Comissao_Pessoa;
SELECT * FROM Inscrito_Simposio;
SELECT * FROM Minicurso_Simposio;
SELECT * FROM Artigo_Simposio;
SELECT * FROM Palestra_Simposio;
SELECT * FROM Organizador_Simposio;
SELECT * FROM Autor_Artigo;
SELECT * FROM Inscricao_Minicurso;
SELECT * FROM Inscricao_Palestra;
SELECT * FROM Inscricao_Artigo;
SELECT * FROM Orador_Minicurso;
SELECT * FROM Orador_Palestra;

-- 1) Nome da pessoa e codigo universitario
SELECT 
    P.nome_completo AS nome_pessoa,
    P.cod_universitario AS codigo_universitario
FROM 
    Pessoa AS P
WHERE 
    P.eh_universitario = TRUE
ORDER BY 
    P.nome_completo ASC;
    
-- 2) Minicursos do simposio 1
SELECT 
    M.id AS id_minicurso,
    M.titulo AS titulo_minicurso
FROM 
    Simposio AS S
JOIN 
    Minicurso_Simposio AS MS ON S.id = MS.id_simposio
JOIN 
    Minicurso AS M ON MS.id_minicurso = M.id
WHERE 
    S.id = 1;

-- 3) Minicursos de todos os simposios (corrigido)
SELECT 
    S.id AS id_simposio,
    S.titulo AS titulo_simposio,  -- Corrigido de nome para titulo
    GROUP_CONCAT(M.titulo ORDER BY M.id SEPARATOR ' - ') AS minicursos
FROM 
    Simposio AS S
JOIN 
    Minicurso_Simposio AS MS ON S.id = MS.id_simposio
JOIN 
    Minicurso AS M ON MS.id_minicurso = M.id
GROUP BY 
    S.id, S.titulo  -- Corrigido de nome para titulo
ORDER BY 
    S.id;

-- 4) Participantes e palestras inscritas (corrigido)
SELECT
    P.id AS id_participante,
    P.nome_completo AS nome_participante,
    PAL.titulo AS titulo_palestra,
    S.titulo AS titulo_simposio
FROM
    Pessoa AS P
JOIN
    Inscricao_Palestra AS IP ON P.id = IP.id_pessoa
JOIN
    Palestra AS PAL ON IP.id_palestra = PAL.id
JOIN
    Palestra_Simposio AS PS ON PAL.id = PS.id_palestra
JOIN
    Simposio AS S ON PS.id_simposio = S.id
WHERE
    P.tipo_pessoa = 'Participante'
ORDER BY
    P.nome_completo, S.titulo;

-- 5) Quantidade de participantes por simposio (corrigido)
SELECT 
    S.titulo AS titulo_simposio,  -- Corrigido de nome para titulo
    COUNT(IS_.id_pessoa) AS total_inscritos
FROM 
    Simposio AS S
LEFT JOIN 
    Inscrito_Simposio AS IS_ ON S.id = IS_.id_evento  
GROUP BY 
    S.id, S.titulo;  -- Corrigido de nome para titulo

-- 6) Quantidade de universitarios por simposio (corrigido)
SELECT 
    S.titulo AS titulo_simposio,  -- Corrigido de nome para titulo
    COUNT(CASE WHEN P.eh_universitario = TRUE THEN 1 ELSE NULL END) AS total_universitarios
FROM 
    Simposio AS S
LEFT JOIN 
    Inscrito_Simposio AS IS_ ON S.id = IS_.id_evento
LEFT JOIN 
    Pessoa AS P ON IS_.id_pessoa = P.id
GROUP BY 
    S.id, S.titulo;  -- Corrigido de nome para titulo

-- 7) Lista de palestrantes (versão corrigida)
SELECT 
    P.id AS id_palestrante,
    P.nome_completo AS nome_palestrante,
    P.cpf,  -- Usando o CPF diretamente da tabela Pessoa
    P.email AS email_palestrante
FROM 
    Pessoa AS P
WHERE 
    P.tipo_pessoa = 'Palestrante';


-- 8) Organizadores dos simposios (versão corrigida)
SELECT 
    S.titulo AS titulo_simposio,  -- Alterado de 'nome' para 'titulo'
    GROUP_CONCAT(DISTINCT P.nome_completo ORDER BY P.nome_completo ASC SEPARATOR ', ') AS organizadores
FROM 
    Simposio AS S
LEFT JOIN 
    Organizador_Simposio AS OS ON S.id = OS.id_simposio
LEFT JOIN 
    Pessoa AS P ON OS.id_pessoa = P.id
GROUP BY 
    S.id, S.titulo  -- Alterado de 'nome' para 'titulo'
ORDER BY 
    S.titulo ASC;  -- Alterado de 'nome' para 'titulo'
    
-- 9) Palestras com dados do orador (versão corrigida)
SELECT 
    PAL.titulo AS titulo_palestra,
    DATE_FORMAT(PAL.data_evento, '%d/%m/%Y') AS data_palestra,
    DATE_FORMAT(PAL.hora_inicio, '%H:%i') AS hora_inicio,
    DATE_FORMAT(PAL.hora_fim, '%H:%i') AS hora_fim,
    P.nome_completo AS nome_orador,
    P.email AS email_orador,
    P.cpf AS cpf_orador  -- Usando o CPF diretamente da tabela Pessoa
FROM 
    Palestra AS PAL
JOIN 
    Orador_Palestra AS OP ON PAL.id = OP.id_palestra
JOIN 
    Pessoa AS P ON OP.id_pessoa = P.id
WHERE
    P.tipo_pessoa = 'Palestrante'
ORDER BY 
    PAL.data_evento ASC, 
    PAL.hora_inicio ASC;
    
-- 10) Universitarios que também são palestrantes (versão corrigida)
SELECT 
    P.nome_completo AS nome_pessoa,
    P.cpf,  -- Usando o CPF diretamente da tabela Pessoa
    P.cod_universitario,
    P.email,
    P.telefone
FROM 
    Pessoa AS P
WHERE 
    P.tipo_pessoa = 'Palestrante'
    AND P.eh_universitario = TRUE
ORDER BY 
    P.nome_completo ASC;

-- 11) Minicursos com maiores numeros de inscritos
SELECT 
    M.titulo AS minicurso,
    COUNT(IM.id_pessoa) AS total_inscritos
FROM Minicurso AS M
LEFT JOIN Inscricao_Minicurso AS IM ON M.id = IM.id_minicurso
GROUP BY M.id
ORDER BY total_inscritos DESC;
    
-- 12) Horarios das palestras e palestrantes
SELECT 
    P.nome_completo AS palestrante,
    COUNT(OP.id_palestra) AS total_palestras,
    GROUP_CONCAT(
        DISTINCT CONCAT(
            PAL.titulo, ' (', DATE_FORMAT(PAL.data_evento, '%d/%m/%Y'), ' - ', 
            PAL.hora_inicio, ' às ', PAL.hora_fim, ')'
        ) 
        SEPARATOR '; '
    ) AS detalhes_palestras
FROM 
    Pessoa AS P
JOIN 
    Orador_Palestra AS OP ON P.id = OP.id_pessoa
JOIN 
    Palestra AS PAL ON OP.id_palestra = PAL.id
GROUP BY 
    P.id;
    
-- 13) Porcentagem de ocupacao simposio
SELECT 
    S.titulo AS simposio,
    S.capacidade,
    COUNT(IS_.id_pessoa) AS inscritos,
    CASE 
        WHEN S.capacidade = 0 THEN '0%'
        ELSE CONCAT(
            ROUND(
                (COUNT(IS_.id_pessoa) * 100.0 / S.capacidade), 1
            ), 
            '%'
        )
    END AS ocupacao
FROM Simposio AS S
LEFT JOIN Inscrito_Simposio AS IS_ ON S.id = IS_.id_evento
GROUP BY S.id, S.titulo, S.capacidade;

-- 14) Inscricao feitas depois de 26/04/2025 (versão corrigida)
SELECT 
    S.titulo AS simposio,  -- Alterado de 'nome' para 'titulo'
    P.nome_completo AS participante,
    DATE_FORMAT(IS_.data_inscricao, '%d/%m/%Y %H:%i') AS data_inscricao_br
FROM Inscrito_Simposio AS IS_
JOIN Simposio AS S ON IS_.id_evento = S.id
JOIN Pessoa AS P ON IS_.id_pessoa = P.id
WHERE IS_.data_inscricao >= '2025-04-26';

-- 15) Quantidade de artigos aprovados e repovados por comissao
SELECT 
    C.nome AS comissao,
    SUM(CASE WHEN A.avaliacao = 'Aprovado' THEN 1 ELSE 0 END) AS aprovados,
    SUM(CASE WHEN A.avaliacao = 'Reprovado' THEN 1 ELSE 0 END) AS reprovados,
    ROUND(AVG(A.nota_avaliacao), 1) AS media_notas
FROM Comissao AS C
LEFT JOIN Artigo AS A ON C.id = A.id_comissao
GROUP BY C.id;