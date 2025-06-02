USE formulario_clientes;

-- Consultas para exibir os dados

-- 1. Dados básicos dos clientes
SELECT * FROM clientes;

-- 2. Cargos ocupados por cliente
SELECT c.nome AS cliente, co.cargo, co.data_inicio, co.data_fim
FROM cargos_ocupados co
JOIN clientes c ON co.cliente_id = c.id
ORDER BY c.nome, co.data_inicio;

-- 3. Cargos no departamento de locação
SELECT c.nome AS cliente, dl.cargo, dl.data_inicio, dl.data_fim
FROM departamento_locacao dl
JOIN clientes c ON dl.cliente_id = c.id
ORDER BY c.nome, dl.data_inicio;

-- 4. Dependentes com grau de parentesco
SELECT c.nome AS cliente, d.nome AS dependente, d.data_nascimento, gp.descricao AS grau_parentesco
FROM dependentes d
JOIN clientes c ON d.cliente_id = c.id
LEFT JOIN graus_parentesco gp ON d.grau_parentesco_id = gp.id
ORDER BY c.nome, d.nome;

-- 5. Visão completa resumida (clientes, cargos, departamento locação e dependentes)
SELECT 
  c.id AS cliente_id,
  c.nome AS cliente_nome,
  co.cargo AS cargo_ocupado,
  co.data_inicio AS cargo_inicio,
  co.data_fim AS cargo_fim,
  dl.cargo AS cargo_locacao,
  dl.data_inicio AS locacao_inicio,
  dl.data_fim AS locacao_fim,
  d.nome AS dependente_nome,
  d.data_nascimento AS dependente_nascimento,
  gp.descricao AS grau_parentesco
FROM clientes c
LEFT JOIN cargos_ocupados co ON co.cliente_id = c.id
LEFT JOIN departamento_locacao dl ON dl.cliente_id = c.id
LEFT JOIN dependentes d ON d.cliente_id = c.id
LEFT JOIN graus_parentesco gp ON d.grau_parentesco_id = gp.id
ORDER BY c.nome;