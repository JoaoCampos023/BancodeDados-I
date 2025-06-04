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

-- Tabela de Cargos Gerais
CREATE TABLE cargos_gerais (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao VARCHAR(255),
    nivel VARCHAR(50),
    INDEX idx_cargo_geral_nome (nome)
);

-- Tabela de Ligação entre Cargos e Departamentos (Muitos para Muitos)
CREATE TABLE cargos_departamentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cargo_geral_id INT NOT NULL,
    departamento_id INT NOT NULL,
    descricao VARCHAR(255),
    FOREIGN KEY (cargo_geral_id) REFERENCES cargos_gerais(id) ON DELETE CASCADE,
    FOREIGN KEY (departamento_id) REFERENCES departamentos(id) ON DELETE CASCADE,
    UNIQUE KEY uk_cargo_departamento (cargo_geral_id, departamento_id),
    INDEX idx_cargo_departamento (cargo_geral_id, departamento_id)
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
    cargo_departamento_id INT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    is_atual BOOLEAN DEFAULT FALSE,
    salario DECIMAL(10,2),
    motivo_saida VARCHAR(255),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE,
    FOREIGN KEY (cargo_departamento_id) REFERENCES cargos_departamentos(id),
    CHECK (data_fim IS NULL OR data_fim > data_inicio),
    INDEX idx_historico_cliente (cliente_id),
    INDEX idx_historico_cargo_dep (cargo_departamento_id),
    INDEX idx_historico_periodo (data_inicio, data_fim)
);