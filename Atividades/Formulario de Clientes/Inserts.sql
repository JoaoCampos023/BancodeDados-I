USE Formulario_De_Cliente;

-- Inserção de graus de parentesco
INSERT INTO graus_parentesco (descricao) VALUES
('Filho'), ('Filha'), ('Cônjuge'), ('Pai'), ('Mãe'),
('Irmão'), ('Irmã'), ('Enteado'), ('Enteada'), ('Outro');

-- Inserção de departamentos
INSERT INTO departamentos (nome, descricao) VALUES
('Locação', 'Departamento responsável por operações de locação'),
('TI', 'Tecnologia da Informação'),
('Financeiro', 'Departamento Financeiro'),
('Operações', 'Área de Operações'),
('Administrativo', 'Área Administrativa'),
('RH', 'Recursos Humanos'),
('Comercial', 'Área Comercial');

-- Inserção de cargos gerais
INSERT INTO cargos_gerais (nome, descricao, nivel) VALUES
('Técnico de Suporte', 'Suporte técnico de TI', 'Júnior'),
('Analista de Sistemas', 'Desenvolvimento e análise de sistemas', 'Pleno'),
('Coordenador', 'Coordenação de equipe', 'Sênior'),
('Assistente', 'Assistência administrativa', 'Júnior'),
('Analista Financeiro', 'Análise financeira', 'Pleno'),
('Engenheiro', 'Engenharia de produção/sistemas', 'Pleno'),
('Gerente', 'Gerência de área', 'Sênior'),
('Supervisor', 'Supervisão de equipe', 'Pleno'),
('Estagiário', 'Estágio em diversas áreas', 'Estagiário'),
('Auxiliar', 'Auxiliar administrativo', 'Júnior'),
('Vendedor', 'Atendimento comercial', 'Júnior'),
('Analista de Crédito', 'Análise de crédito e cobrança', 'Pleno'),
('Analista de RH', 'Análise de recursos humanos', 'Pleno');

-- Inserção corrigida de cargos por departamento (sem duplicatas)
INSERT INTO cargos_departamentos (cargo_geral_id, departamento_id, descricao) VALUES
-- TI
(1, 2, 'Técnico de Suporte de TI'),
(2, 2, 'Analista de Sistemas de TI'),
(3, 2, 'Coordenador de TI'),
(6, 2, 'Gerente de TI'),
(8, 2, 'Supervisor de Suporte'),

-- Financeiro
(4, 3, 'Assistente Financeiro'),
(5, 3, 'Analista Financeiro'),
(8, 3, 'Supervisor Financeiro'),
(9, 3, 'Estagiário Financeiro'),
(12, 3, 'Analista de Crédito'),
(3, 3, 'Coordenador Financeiro'),

-- Operações
(5, 4, 'Analista de Operações'),
(6, 4, 'Engenheiro de Produção'),
(7, 4, 'Gerente de Operações'),
(3, 4, 'Coordenador de Operações'),

-- Administrativo
(4, 5, 'Assistente Administrativo'),
(10, 5, 'Auxiliar Administrativo'),
(8, 5, 'Supervisor Administrativo'),
(3, 5, 'Coordenador Administrativo'),

-- RH
(7, 6, 'Gerente de RH'),
(13, 6, 'Analista de RH'),

-- Comercial
(11, 7, 'Vendedor'),
(3, 7, 'Coordenador Comercial');

-- Inserção de clientes
INSERT INTO clientes (matricula, nome, data_nascimento, nacionalidade, sexo, estado_civil, rg, cpf, endereco, data_admissao, telefone, email) VALUES
('2023001', 'João da Silva', '1985-04-23', 'Brasileira', 'Masculino', 'Casado', 'MG123456', '123.456.789-00', 'Rua A, 123', '2010-01-15', '(31) 9999-8888', 'joao.silva@email.com'),
('2023002', 'Maria Oliveira', '1990-08-15', 'Brasileira', 'Feminino', 'Solteira', 'SP654321', '987.654.321-00', 'Rua B, 456', '2015-03-20', '(11) 98888-7777', 'maria.oliveira@email.com'),
('2023003', 'Carlos Souza', '1982-11-30', 'Brasileira', 'Masculino', 'Divorciado', 'RJ789456', '456.789.123-00', 'Rua C, 789', '2012-07-01', '(21) 97777-6666', 'carlos.souza@email.com'),
('2023004', 'Ana Costa', '1975-07-10', 'Brasileira', 'Feminino', 'Viúva', 'DF321987', '321.654.987-00', 'Rua D, 321', '2005-09-10', '(61) 96666-5555', 'ana.costa@email.com'),
('2023005', 'Fernanda Lima', '1988-02-28', 'Brasileira', 'Feminino', 'Casada', 'PR111222', '111.222.333-44', 'Rua E, 555', '2018-06-05', '(41) 95555-4444', 'fernanda.lima@email.com'),
('2023006', 'Eduardo Silva', '1978-06-12', 'Brasileira', 'Masculino', 'Casado', 'RJ333444', '555.666.777-88', 'Rua F, 222', '2008-12-20', '(21) 94444-3333', 'eduardo.silva@email.com'),
('2023007', 'Patrícia Carvalho', '1993-09-07', 'Brasileira', 'Feminino', 'Solteira', 'MG555666', '999.888.777-66', 'Rua G, 999', '2021-11-10', '(31) 93333-2222', 'patricia.carvalho@email.com');

-- Inserção de histórico profissional (atualizada com os novos IDs de cargos_departamentos)
INSERT INTO historico_profissional (cliente_id, cargo_departamento_id, data_inicio, data_fim, is_atual, salario) VALUES
(1, 3, '2016-01-01', NULL, TRUE, 8500.00),  -- Coordenador de TI
(1, 2, '2010-01-15', '2015-12-31', FALSE, 4500.00),  -- Analista de Sistemas de TI
(2, 6, '2018-08-16', NULL, TRUE, 6200.00),  -- Analista Financeiro
(2, 9, '2015-03-20', '2016-12-31', FALSE, 1500.00),  -- Estagiário Financeiro
(2, 11, '2017-01-01', '2018-08-15', FALSE, 3800.00),  -- Analista de Crédito
(3, 14, '2021-01-01', NULL, TRUE, 9200.00),  -- Gerente de Operações
(3, 13, '2012-07-01', '2020-12-31', FALSE, 5800.00),  -- Engenheiro de Produção
(4, 19, '2010-06-01', NULL, TRUE, 5300.00),  -- Supervisor Administrativo
(4, 17, '2005-09-10', '2010-05-30', FALSE, 2200.00),  -- Auxiliar Administrativo
(5, 11, '2018-06-05', NULL, TRUE, 4200.00),  -- Analista de Crédito
(6, 14, '2015-01-01', NULL, TRUE, 8800.00),  -- Gerente de Operações
(6, 13, '2008-12-20', '2014-12-31', FALSE, 4800.00),  -- Engenheiro de Produção
(7, 2, '2021-11-10', NULL, TRUE, 5200.00);  -- Analista de Sistemas de TI

-- Inserção de dependentes
INSERT INTO dependentes (cliente_id, nome, data_nascimento, grau_parentesco_id) VALUES
(1, 'Lucas da Silva', '2010-05-10', 1),
(1, 'Fernanda da Silva', '2012-08-20', 2),
(2, 'Pedro Oliveira', '2018-02-14', 1),
(5, 'Pedro Mendes', '2012-04-25', 1),
(6, 'Larissa Silva', '2010-10-05', 2),
(6, 'João Vinícius Silva', '2013-07-18', 1),
(7, 'Camila Carvalho', '2015-02-14', 2);