USE Aeroporto;

-- Consultar voos completos
SELECT * FROM view_voos_completos;

-- Ver poltronas disponíveis para um voo
SELECT * FROM view_poltronas_disponiveis WHERE id_voo = 1 AND disponivel = TRUE;

-- Ver clientes frequentes
SELECT * FROM view_clientes_frequentes;