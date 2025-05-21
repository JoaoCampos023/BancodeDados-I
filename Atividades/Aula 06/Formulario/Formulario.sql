CREATE DATABASE IF NOT EXISTS formulario_clientes;

USE formulario_clientes;

-- Tabela principal: Clientes
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    matricula VARCHAR(20) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE,
    nacionalidade VARCHAR(50),
    sexo ENUM('Masculino', 'Feminino', 'Outro'),
    estado_civil VARCHAR(30),
    rg VARCHAR(20),
    cpf VARCHAR(20),
    endereco VARCHAR(255),
    data_admissao DATE
);

-- Tabela: Cargos Ocupados
CREATE TABLE cargos_ocupados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    cargo VARCHAR(100),
    data_inicio DATE,
    data_fim DATE,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE
);

-- Tabela: Departamento de Locação
CREATE TABLE departamento_locacao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    cargo VARCHAR(100),
    data_inicio DATE,
    data_fim DATE,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE
);

-- Tabela: Graus de Parentesco
CREATE TABLE graus_parentesco (
    id INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(50) NOT NULL UNIQUE
);

-- Tabela: Dependentes
CREATE TABLE dependentes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    nome VARCHAR(100),
    data_nascimento DATE,
    grau_parentesco_id INT,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE,
    FOREIGN KEY (grau_parentesco_id) REFERENCES graus_parentesco(id) ON DELETE SET NULL
);

-- Inserção de graus de parentesco
INSERT INTO graus_parentesco (descricao) VALUES
('Filho'),
('Filha'),
('Cônjuge'),
('Pai'),
('Mãe'),
('Irmão'),
('Irmã'),
('Enteado'),
('Enteada');

-- Inserção de clientes
INSERT INTO clientes (matricula, nome, data_nascimento, nacionalidade, sexo, estado_civil, rg, cpf, endereco, data_admissao)
VALUES
('2023001', 'João da Silva', '1985-04-23', 'Brasileira', 'Masculino', 'Casado', 'MG123456', '123.456.789-00', 'Rua A, 123', '2010-01-15'),
('2023002', 'Maria Oliveira', '1990-08-15', 'Brasileira', 'Feminino', 'Solteira', 'SP654321', '987.654.321-00', 'Rua B, 456', '2015-03-20'),
('2023003', 'Carlos Souza', '1982-11-30', 'Brasileira', 'Masculino', 'Divorciado', 'RJ789456', '456.789.123-00', 'Rua C, 789', '2012-07-01'),
('2023004', 'Ana Costa', '1975-07-10', 'Brasileira', 'Feminino', 'Viúva', 'DF321987', '321.654.987-00', 'Rua D, 321', '2005-09-10'),
('2023005', 'Fernanda Lima', '1988-02-28', 'Brasileira', 'Feminino', 'Casada', 'PR111222', '111.222.333-44', 'Rua E, 555', '2018-06-05'),
('2023006', 'Eduardo Silva', '1978-06-12', 'Brasileira', 'Masculino', 'Casado', 'RJ333444', '555.666.777-88', 'Rua F, 222', '2008-12-20'),
('2023007', 'Patrícia Carvalho', '1993-09-07', 'Brasileira', 'Feminino', 'Solteira', 'MG555666', '999.888.777-66', 'Rua G, 999', '2021-11-10');

-- Inserção de cargos ocupados
INSERT INTO cargos_ocupados (cliente_id, cargo, data_inicio, data_fim)
VALUES
(1, 'Analista de Sistemas', '2010-01-15', '2015-12-31'),
(1, 'Coordenador de TI', '2016-01-01', NULL),
(2, 'Assistente Administrativo', '2015-03-20', '2018-08-15'),
(2, 'Analista Financeiro', '2018-08-16', NULL),
(3, 'Engenheiro de Produção', '2012-07-01', '2020-12-31'),
(3, 'Gerente de Operações', '2021-01-01', NULL);

-- Inserção no departamento de locação
INSERT INTO departamento_locacao (cliente_id, cargo, data_inicio, data_fim)
VALUES
(1, 'Técnico de Suporte', '2010-01-15', '2012-12-31'),
(1, 'Supervisor de Suporte', '2013-01-01', '2015-12-31'),
(2, 'Estagiária Financeiro', '2015-03-20', '2016-12-31'),
(2, 'Analista de Crédito', '2017-01-01', NULL),
(4, 'Auxiliar Administrativa', '2005-09-10', '2010-05-30'),
(4, 'Supervisora Administrativa', '2010-06-01', NULL);

-- Inserção de dependentes
INSERT INTO dependentes (cliente_id, nome, data_nascimento, grau_parentesco_id)
VALUES
(1, 'Lucas da Silva', '2010-05-10', 1),  -- Filho
(1, 'Fernanda da Silva', '2012-08-20', 2),  -- Filha
(2, 'Pedro Oliveira', '2018-02-14', 1),  -- Filho
(5, 'Pedro Mendes', '2012-04-25', 1),  -- Filho
(6, 'Larissa Silva', '2010-10-05', 2),  -- Filha
(6, 'João Vinícius Silva', '2013-07-18', 1),  -- Filho
(7, 'Camila Carvalho', '2015-02-14', 2);  -- Filha
