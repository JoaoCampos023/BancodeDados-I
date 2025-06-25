USE Aeroporto;

-- View para mostrar informações completas de voos
CREATE VIEW view_voos_completos AS
SELECT 
    v.id_voo,
    v.numero_voo,
    a.modelo AS aeronave,
    ao.nome AS aeroporto_origem,
    ao.codigo_iata AS iata_origem,
    ad.nome AS aeroporto_destino,
    ad.codigo_iata AS iata_destino,
    v.horario_saida,
    v.horario_chegada_previsto,
    v.status,
    TIMESTAMPDIFF(MINUTE, v.horario_saida, v.horario_chegada_previsto) AS duracao_minutos
FROM 
    voos v
JOIN 
    aeronaves a ON v.id_aeronave = a.id_aeronave
JOIN 
    rotas r ON v.id_rota = r.id_rota
JOIN 
    aeroportos ao ON r.id_aeroporto_origem = ao.id_aeroporto
JOIN 
    aeroportos ad ON r.id_aeroporto_destino = ad.id_aeroporto;

-- View para mostrar poltronas disponíveis por voo
CREATE VIEW view_poltronas_disponiveis AS
SELECT 
    v.id_voo,
    v.numero_voo,
    p.numero_poltrona,
    c.nome AS classe,
    c.multiplicador_preco,
    cpv.disponivel,
    CASE 
        WHEN cpv.disponivel = TRUE THEN 'Disponível'
        ELSE 'Ocupada'
    END AS status_poltrona
FROM 
    config_poltronas_voo cpv
JOIN 
    voos v ON cpv.id_voo = v.id_voo
JOIN 
    poltronas p ON cpv.id_poltrona = p.id_poltrona
JOIN 
    classes c ON p.id_classe = c.id_classe;

-- View para clientes frequentes
CREATE VIEW view_clientes_frequentes AS
SELECT 
    c.id_cliente,
    c.nome,
    c.nivel_preferencia,
    c.milhas_accumuladas,
    c.frequencia_voos_ano,
    COUNT(r.id_reserva) AS total_reservas,
    SUM(r.valor_total) AS total_gasto
FROM 
    clientes c
LEFT JOIN 
    reservas r ON c.id_cliente = r.id_cliente
GROUP BY 
    c.id_cliente, c.nome, c.nivel_preferencia, c.milhas_accumuladas, c.frequencia_voos_ano
ORDER BY 
    c.nivel_preferencia DESC, c.milhas_accumuladas DESC;

-- View para relatório financeiro por voo
CREATE VIEW view_relatorio_financeiro_voo AS
SELECT 
    v.id_voo,
    v.numero_voo,
    COUNT(r.id_reserva) AS poltronas_vendidas,
    a.numero_poltronas AS capacidade_total,
    CONCAT(ROUND((COUNT(r.id_reserva) / a.numero_poltronas) * 100, 2), '%') AS ocupacao,
    SUM(r.valor_total) AS receita_total,
    AVG(r.valor_total) AS ticket_medio
FROM 
    voos v
JOIN 
    aeronaves a ON v.id_aeronave = a.id_aeronave
LEFT JOIN 
    config_poltronas_voo cpv ON v.id_voo = cpv.id_voo
LEFT JOIN 
    reservas r ON cpv.id_config = r.id_config
GROUP BY 
    v.id_voo, v.numero_voo, a.numero_poltronas;
    
CREATE VIEW view_voos_internacionais AS
SELECT 
    v.*, 
    ao.pais AS pais_origem, 
    ad.pais AS pais_destino,
    ao.nome AS aeroporto_origem,
    ad.nome AS aeroporto_destino
FROM 
    voos v
JOIN 
    rotas r ON v.id_rota = r.id_rota
JOIN 
    aeroportos ao ON r.id_aeroporto_origem = ao.id_aeroporto
JOIN 
    aeroportos ad ON r.id_aeroporto_destino = ad.id_aeroporto
WHERE 
    ao.pais != ad.pais;

CREATE VIEW view_poltronas_preferidas AS
SELECT 
    c.nome AS classe,
    p.localizacao,
    p.lado,
    COUNT(r.id_reserva) AS total_reservas,
    ROUND(COUNT(r.id_reserva) * 100.0 / SUM(COUNT(r.id_reserva)) OVER (PARTITION BY c.nome), 2) AS percentual_classe
FROM 
    reservas r
JOIN 
    config_poltronas_voo cpv ON r.id_config = cpv.id_config
JOIN 
    poltronas p ON cpv.id_poltrona = p.id_poltrona
JOIN 
    classes c ON p.id_classe = c.id_classe
WHERE 
    r.status != 'Cancelada'
GROUP BY 
    c.id_classe, c.nome, p.localizacao, p.lado;

CREATE VIEW view_clientes_promocao AS
SELECT 
    id_cliente,
    nome,
    nivel_preferencia AS nivel_atual,
    milhas_accumuladas,
    CASE 
        WHEN milhas_accumuladas >= 30000 THEN 'Diamante'
        WHEN milhas_accumuladas >= 15000 THEN 'Ouro'
        WHEN milhas_accumuladas >= 7500 THEN 'Prata'
        ELSE 'Bronze'
    END AS nivel_sugerido,
    CASE 
        WHEN milhas_accumuladas >= 30000 AND nivel_preferencia != 'Diamante' THEN TRUE
        WHEN milhas_accumuladas >= 15000 AND milhas_accumuladas < 30000 AND nivel_preferencia NOT IN ('Diamante', 'Ouro') THEN TRUE
        WHEN milhas_accumuladas >= 7500 AND milhas_accumuladas < 15000 AND nivel_preferencia NOT IN ('Diamante', 'Ouro', 'Prata') THEN TRUE
        ELSE FALSE
    END AS elegivel_promocao
FROM 
    clientes
ORDER BY 
    milhas_accumuladas DESC;
    

-- View para mostrar voos com maior potencial de receita
CREATE VIEW view_voos_maior_receita AS
SELECT 
    v.id_voo,
    v.numero_voo,
    ao.nome AS origem,
    ad.nome AS destino,
    v.horario_saida,
    COUNT(r.id_reserva) AS poltronas_vendidas,
    SUM(r.valor_total) AS receita_atual,
    (a.numero_poltronas - COUNT(r.id_reserva)) * AVG(r.valor_total) AS potencial_receita_restante
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
    v.status = 'Agendado'
    AND v.horario_saida > NOW()
GROUP BY 
    v.id_voo, v.numero_voo, ao.nome, ad.nome, v.horario_saida, a.numero_poltronas
ORDER BY 
    potencial_receita_restante DESC;

-- View para mostrar eficiência de aeronaves
CREATE VIEW view_eficiencia_aeronaves AS
SELECT 
    a.id_aeronave,
    a.modelo,
    a.fabricante,
    a.ano_fabricacao,
    COUNT(DISTINCT v.id_voo) AS total_voos,
    COUNT(DISTINCT CASE WHEN v.status = 'Aterrissado' THEN v.id_voo END) AS voos_concluidos,
    COUNT(DISTINCT CASE WHEN v.status = 'Cancelado' THEN v.id_voo END) AS voos_cancelados,
    IFNULL(SUM(r.valor_total), 0) AS receita_total,
    IFNULL(AVG(hv.tempo_atraso), 0) AS media_atraso_minutos
FROM 
    aeronaves a
LEFT JOIN 
    voos v ON a.id_aeronave = v.id_aeronave
LEFT JOIN 
    config_poltronas_voo cpv ON v.id_voo = cpv.id_voo
LEFT JOIN 
    reservas r ON cpv.id_config = r.id_config AND r.status != 'Cancelada'
LEFT JOIN 
    historico_voos hv ON v.id_voo = hv.id_voo
GROUP BY 
    a.id_aeronave, a.modelo, a.fabricante, a.ano_fabricacao
ORDER BY 
    receita_total DESC;

-- View para mostrar preferências de clientes por rota
CREATE VIEW view_preferencias_rotas AS
SELECT 
    rt.id_rota,
    ao.nome AS origem,
    ad.nome AS destino,
    COUNT(DISTINCT r.id_cliente) AS clientes_unicos,
    COUNT(r.id_reserva) AS total_reservas,
    SUM(r.valor_total) AS receita_total,
    AVG(c.milhas_accumuladas) AS media_milhas_clientes,
    GROUP_CONCAT(DISTINCT c.nivel_preferencia ORDER BY 
        CASE c.nivel_preferencia
            WHEN 'Diamante' THEN 1
            WHEN 'Ouro' THEN 2
            WHEN 'Prata' THEN 3
            ELSE 4
        END SEPARATOR ', ') AS niveis_preferencia
FROM 
    rotas rt
JOIN 
    aeroportos ao ON rt.id_aeroporto_origem = ao.id_aeroporto
JOIN 
    aeroportos ad ON rt.id_aeroporto_destino = ad.id_aeroporto
LEFT JOIN 
    voos v ON rt.id_rota = v.id_rota
LEFT JOIN 
    config_poltronas_voo cpv ON v.id_voo = cpv.id_voo
LEFT JOIN 
    reservas r ON cpv.id_config = r.id_config AND r.status != 'Cancelada'
LEFT JOIN 
    clientes c ON r.id_cliente = c.id_cliente
GROUP BY 
    rt.id_rota, ao.nome, ad.nome
ORDER BY 
    receita_total DESC;