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