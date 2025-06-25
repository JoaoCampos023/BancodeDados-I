USE Aeroporto;

SELECT v.id_voo, v.numero_voo, 
       ao.nome AS origem, ad.nome AS destino,
       v.horario_saida, v.horario_chegada_previsto, v.status
FROM voos v
JOIN rotas r ON v.id_rota = r.id_rota
JOIN aeroportos ao ON r.id_aeroporto_origem = ao.id_aeroporto
JOIN aeroportos ad ON r.id_aeroporto_destino = ad.id_aeroporto
WHERE v.status = 'Agendado'
ORDER BY v.horario_saida;

SELECT p.numero_poltrona, c.nome AS classe, 
       p.localizacao, p.lado, c.multiplicador_preco
FROM config_poltronas_voo cpv
JOIN poltronas p ON cpv.id_poltrona = p.id_poltrona
JOIN classes c ON p.id_classe = c.id_classe
WHERE cpv.id_voo = 1 AND cpv.disponivel = TRUE
ORDER BY c.id_classe, p.numero_poltrona;

SELECT nome, cpf, nivel_preferencia, milhas_accumuladas, 
       data_ultimo_voo, frequencia_voos_ano
FROM clientes
ORDER BY 
    CASE nivel_preferencia
        WHEN 'Diamante' THEN 1
        WHEN 'Ouro' THEN 2
        WHEN 'Prata' THEN 3
        ELSE 4
    END, milhas_accumuladas DESC;
    
SELECT v.numero_voo, ao.nome AS origem, ao.pais AS pais_origem,
       ad.nome AS destino, ad.pais AS pais_destino,
       v.horario_saida, v.horario_chegada_previsto
FROM voos v
JOIN rotas r ON v.id_rota = r.id_rota
JOIN aeroportos ao ON r.id_aeroporto_origem = ao.id_aeroporto
JOIN aeroportos ad ON r.id_aeroporto_destino = ad.id_aeroporto
WHERE ao.pais != ad.pais
ORDER BY v.horario_saida;

SELECT v.numero_voo, a.modelo AS aeronave,
       COUNT(r.id_reserva) AS poltronas_vendidas,
       a.numero_poltronas AS capacidade,
       CONCAT(ROUND((COUNT(r.id_reserva) / a.numero_poltronas) * 100, 2), '%') AS ocupacao,
       SUM(r.valor_total) AS receita_total
FROM voos v
JOIN aeronaves a ON v.id_aeronave = a.id_aeronave
LEFT JOIN config_poltronas_voo cpv ON v.id_voo = cpv.id_voo
LEFT JOIN reservas r ON cpv.id_config = r.id_config AND r.status != 'Cancelada'
GROUP BY v.id_voo, v.numero_voo, a.modelo, a.numero_poltronas
ORDER BY ocupacao DESC;

SELECT id_cliente, nome, nivel_preferencia AS nivel_atual, milhas_accumuladas,
       CASE 
           WHEN milhas_accumuladas >= 30000 THEN 'Diamante'
           WHEN milhas_accumuladas >= 15000 THEN 'Ouro'
           WHEN milhas_accumuladas >= 7500 THEN 'Prata'
           ELSE 'Bronze'
       END AS nivel_sugerido
FROM clientes
WHERE 
    (milhas_accumuladas >= 30000 AND nivel_preferencia != 'Diamante') OR
    (milhas_accumuladas >= 15000 AND milhas_accumuladas < 30000 AND nivel_preferencia NOT IN ('Diamante', 'Ouro')) OR
    (milhas_accumuladas >= 7500 AND milhas_accumuladas < 15000 AND nivel_preferencia NOT IN ('Diamante', 'Ouro', 'Prata'))
ORDER BY milhas_accumuladas DESC;

SELECT a.modelo, a.fabricante, 
       COUNT(hv.id_historico) AS total_voos,
       AVG(hv.tempo_atraso) AS media_atraso_minutos,
       MAX(hv.tempo_atraso) AS maior_atraso,
       GROUP_CONCAT(DISTINCT hv.motivo_atraso SEPARATOR '; ') AS motivos
FROM aeronaves a
JOIN voos v ON a.id_aeronave = v.id_aeronave
JOIN historico_voos hv ON v.id_voo = hv.id_voo
WHERE hv.tempo_atraso > 0
GROUP BY a.id_aeronave, a.modelo, a.fabricante
ORDER BY media_atraso DESC;

SELECT c.nome AS classe, 
       COUNT(r.id_reserva) AS total_reservas,
       SUM(r.valor_total) AS receita_total,
       AVG(r.valor_total) AS ticket_medio
FROM reservas r
JOIN config_poltronas_voo cpv ON r.id_config = cpv.id_config
JOIN poltronas p ON cpv.id_poltrona = p.id_poltrona
JOIN classes c ON p.id_classe = c.id_classe
JOIN voos v ON cpv.id_voo = v.id_voo
WHERE r.status != 'Cancelada'
  AND v.horario_saida BETWEEN '2023-12-01' AND '2023-12-31'
GROUP BY c.id_classe, c.nome
ORDER BY receita_total DESC;

SELECT c.nome AS classe, p.localizacao, p.lado,
       COUNT(r.id_reserva) AS total_reservas,
       ROUND(COUNT(r.id_reserva) * 100.0 / SUM(COUNT(r.id_reserva)) OVER (PARTITION BY c.nome), 2) AS percentual
FROM reservas r
JOIN config_poltronas_voo cpv ON r.id_config = cpv.id_config
JOIN poltronas p ON cpv.id_poltrona = p.id_poltrona
JOIN classes c ON p.id_classe = c.id_classe
WHERE r.status != 'Cancelada'
GROUP BY c.id_classe, c.nome, p.localizacao, p.lado
ORDER BY c.id_classe, total_reservas DESC;

SELECT a.modelo, a.fabricante, a.ano_fabricacao,
       COUNT(DISTINCT CASE WHEN v.status = 'Aterrissado' THEN v.id_voo END) AS voos_concluidos,
       COUNT(DISTINCT CASE WHEN v.status = 'Cancelado' THEN v.id_voo END) AS voos_cancelados,
       ROUND(COUNT(DISTINCT CASE WHEN v.status = 'Aterrissado' THEN v.id_voo END) * 100.0 / 
             COUNT(DISTINCT v.id_voo), 2) AS taxa_sucesso
FROM aeronaves a
LEFT JOIN voos v ON a.id_aeronave = v.id_aeronave
GROUP BY a.id_aeronave, a.modelo, a.fabricante, a.ano_fabricacao
ORDER BY taxa_sucesso DESC;

SELECT 
    DATE_FORMAT(v.horario_saida, '%Y-%m') AS mes,
    COUNT(DISTINCT v.id_voo) AS total_voos,
    COUNT(r.id_reserva) AS total_reservas,
    SUM(r.valor_total) AS receita_total,
    AVG(r.valor_total) AS ticket_medio,
    SUM(a.numero_poltronas) AS capacidade_total,
    ROUND(COUNT(r.id_reserva) * 100.0 / SUM(a.numero_poltronas), 2) AS ocupacao_percentual
FROM voos v
JOIN aeronaves a ON v.id_aeronave = a.id_aeronave
LEFT JOIN config_poltronas_voo cpv ON v.id_voo = cpv.id_voo
LEFT JOIN reservas r ON cpv.id_config = r.id_config AND r.status != 'Cancelada'
GROUP BY DATE_FORMAT(v.horario_saida, '%Y-%m')
ORDER BY mes;

SELECT c.id_cliente, c.nome, c.nivel_preferencia,
       COUNT(r.id_reserva) AS total_reservas,
       SUM(r.valor_total) AS total_gasto,
       c.milhas_accumuladas,
       c.frequencia_voos_ano
FROM clientes c
LEFT JOIN reservas r ON c.id_cliente = r.id_cliente AND r.status != 'Cancelada'
GROUP BY c.id_cliente, c.nome, c.nivel_preferencia, c.milhas_accumuladas, c.frequencia_voos_ano
ORDER BY total_gasto DESC
LIMIT 10;

SELECT 
    ao.nome AS origem, ad.nome AS destino,
    COUNT(DISTINCT v.id_voo) AS total_voos,
    COUNT(r.id_reserva) AS total_passageiros,
    SUM(r.valor_total) AS receita_total,
    ROUND(AVG(r.valor_total), 2) AS ticket_medio
FROM rotas rt
JOIN aeroportos ao ON rt.id_aeroporto_origem = ao.id_aeroporto
JOIN aeroportos ad ON rt.id_aeroporto_destino = ad.id_aeroporto
LEFT JOIN voos v ON rt.id_rota = v.id_rota
LEFT JOIN config_poltronas_voo cpv ON v.id_voo = cpv.id_voo
LEFT JOIN reservas r ON cpv.id_config = r.id_config AND r.status != 'Cancelada'
GROUP BY rt.id_rota, ao.nome, ad.nome
ORDER BY total_passageiros DESC
LIMIT 10;

SELECT 
    DAYNAME(v.horario_saida) AS dia_semana,
    COUNT(DISTINCT v.id_voo) AS total_voos,
    COUNT(r.id_reserva) AS total_reservas,
    SUM(r.valor_total) AS receita_total,
    ROUND(AVG(r.valor_total), 2) AS ticket_medio,
    ROUND(COUNT(r.id_reserva) * 100.0 / SUM(a.numero_poltronas), 2) AS ocupacao_percentual
FROM voos v
JOIN aeronaves a ON v.id_aeronave = a.id_aeronave
LEFT JOIN config_poltronas_voo cpv ON v.id_voo = cpv.id_voo
LEFT JOIN reservas r ON cpv.id_config = r.id_config AND r.status != 'Cancelada'
GROUP BY DAYNAME(v.horario_saida), DAYOFWEEK(v.horario_saida)
ORDER BY DAYOFWEEK(v.horario_saida);

SELECT 
    v.numero_voo,
    av.status_anterior,
    av.status_novo,
    av.data_alteracao,
    av.usuario,
    ao.nome AS origem,
    ad.nome AS destino,
    v.horario_saida
FROM auditoria_voo av
JOIN voos v ON av.id_voo = v.id_voo
JOIN rotas r ON v.id_rota = r.id_rota
JOIN aeroportos ao ON r.id_aeroporto_origem = ao.id_aeroporto
JOIN aeroportos ad ON r.id_aeroporto_destino = ad.id_aeroporto
ORDER BY av.data_alteracao DESC
LIMIT 20;

