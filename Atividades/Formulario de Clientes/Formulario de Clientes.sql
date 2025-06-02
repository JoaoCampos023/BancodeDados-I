CREATE DATABASE IF NOT EXISTS Formulario_De_Cliente;

USE Formulario_De_Cliente;

-- Tabela Principal - Clientes.
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    matricula VARCHAR(20) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE,
    nacionalidade VARCHAR(50),
    sexo ENUM('Masculino', 'Feminino', 'Outro'),
    estado_civil VARCHAR(30),
    rg VARCHAR(20) UNIQUE,
    cpf VARCHAR(20) UNIQUE,
    endereco VARCHAR(255),
    data_admissao DATE,
    telefone VARCHAR(20),
    email VARCHAR(100),
    INDEX idx_cliente_nome (nome),
    INDEX idx_cliente_cpf (cpf),
    INDEX idx_cliente_matricula (matricula)
);

-- Tabela de Departamentos
CREATE TABLE departamentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao VARCHAR(255),
    INDEX idx_departamento_nome (nome)
);

-- Tabela de Cargos
CREATE TABLE cargos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    departamento_id INT,
    nivel VARCHAR(50),
    FOREIGN KEY (departamento_id) REFERENCES departamentos(id),
    INDEX idx_cargo_nome (nome),
    INDEX idx_cargo_departamento (departamento_id)
);

-- Tabela de Graus de Parentesco
CREATE TABLE graus_parentesco (
    id INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(50) NOT NULL UNIQUE
);

-- Tabela de Dependentes
CREATE TABLE dependentes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    nome VARCHAR(100),
    data_nascimento DATE,
    grau_parentesco_id INT,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE,
    FOREIGN KEY (grau_parentesco_id) REFERENCES graus_parentesco(id) ON DELETE SET NULL,
    INDEX idx_dependente_cliente (cliente_id)
);


-- Tabela de Histórico Profissional
CREATE TABLE historico_profissional (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    cargo_id INT NOT NULL,
    departamento_id INT,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    is_atual BOOLEAN DEFAULT FALSE,
    salario DECIMAL(10,2),
    motivo_saida VARCHAR(255),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE,
    FOREIGN KEY (cargo_id) REFERENCES cargos(id),
    FOREIGN KEY (departamento_id) REFERENCES departamentos(id),
    CHECK (data_fim IS NULL OR data_fim > data_inicio),
    INDEX idx_historico_cliente (cliente_id),
    INDEX idx_historico_cargo (cargo_id),
    INDEX idx_historico_departamento (departamento_id),
    INDEX idx_historico_periodo (data_inicio, data_fim)
);


-- Tabela para Situação Atual do Cliente
CREATE TABLE situacao_atual (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL UNIQUE,
    cargo_id INT NOT NULL,
    departamento_id INT NOT NULL,
    data_inicio DATE NOT NULL,
    salario DECIMAL(10,2),
    ultima_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE,
    FOREIGN KEY (cargo_id) REFERENCES cargos(id),
    FOREIGN KEY (departamento_id) REFERENCES departamentos(id),
    INDEX idx_situacao_cliente (cliente_id)
);