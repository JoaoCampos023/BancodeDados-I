CREATE DATABASE IF NOT EXISTS Aeroporto;
USE Aeroporto;

-- Tabela de Aeronaves 
CREATE TABLE aeronaves (
    id_aeronave INT AUTO_INCREMENT PRIMARY KEY,
    tipo_aeronave VARCHAR(50) NOT NULL,
    numero_poltronas INT NOT NULL,
    fabricante VARCHAR(50),
    modelo VARCHAR(50),
    ano_fabricacao YEAR,
    UNIQUE (tipo_aeronave, modelo)
);

-- Tabela de Aeroportos 
CREATE TABLE aeroportos (
    id_aeroporto INT AUTO_INCREMENT PRIMARY KEY,
    codigo_iata CHAR(3) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    terminal VARCHAR(20)
);

-- Tabela de Classes 
CREATE TABLE classes (
    id_classe INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT,
    multiplicador_preco DECIMAL(3,2) DEFAULT 1.0
);

-- Tabela de Poltronas 
CREATE TABLE poltronas (
    id_poltrona INT AUTO_INCREMENT PRIMARY KEY,
    id_aeronave INT NOT NULL,
    numero_poltrona VARCHAR(10) NOT NULL,
    localizacao ENUM('Janela', 'Corredor', 'Meio') NOT NULL,
    lado ENUM('Esquerda', 'Direita') NOT NULL,
    id_classe INT NOT NULL,
    FOREIGN KEY (id_aeronave) REFERENCES aeronaves(id_aeronave),
    FOREIGN KEY (id_classe) REFERENCES classes(id_classe),
    UNIQUE (id_aeronave, numero_poltrona)
);

-- Tabela de Voos
CREATE TABLE rotas (
    id_rota INT AUTO_INCREMENT PRIMARY KEY,
    id_aeroporto_origem INT NOT NULL,
    id_aeroporto_destino INT NOT NULL,
    FOREIGN KEY (id_aeroporto_origem) REFERENCES aeroportos(id_aeroporto),
    FOREIGN KEY (id_aeroporto_destino) REFERENCES aeroportos(id_aeroporto),
    CHECK (id_aeroporto_origem != id_aeroporto_destino)
);

CREATE TABLE voos (
    id_voo INT AUTO_INCREMENT PRIMARY KEY,
    numero_voo VARCHAR(10) UNIQUE NOT NULL,
    id_aeronave INT NOT NULL,
    id_rota INT NOT NULL,
    horario_saida DATETIME NOT NULL,
    horario_chegada_previsto DATETIME NOT NULL,
    status ENUM('Agendado', 'Embarque', 'Decolado', 'Aterrissado', 'Cancelado', 'Atrasado') DEFAULT 'Agendado',
    FOREIGN KEY (id_aeronave) REFERENCES aeronaves(id_aeronave),
    FOREIGN KEY (id_rota) REFERENCES rotas(id_rota),
    CHECK (horario_chegada_previsto > horario_saida),
    CONSTRAINT chk_horarios_validos CHECK (
    TIME(horario_saida) BETWEEN '05:00:00' AND '23:59:59' AND
    TIME(horario_chegada_previsto) BETWEEN '05:00:00' AND '23:59:59')
);

-- Tabela de Configuração de Poltronas por Voo
CREATE TABLE config_poltronas_voo (
    id_config INT AUTO_INCREMENT PRIMARY KEY,
    id_voo INT NOT NULL,
    id_poltrona INT NOT NULL,
    disponivel BOOLEAN DEFAULT TRUE,
    status_poltrona VARCHAR(10) GENERATED ALWAYS AS (CASE WHEN disponivel THEN 'Disponível' ELSE 'Ocupada' END) STORED,
    FOREIGN KEY (id_voo) REFERENCES voos(id_voo),
    FOREIGN KEY (id_poltrona) REFERENCES poltronas(id_poltrona),
    UNIQUE (id_voo, id_poltrona)
);

-- Tabela de Escalas
CREATE TABLE escalas (
    id_escala INT AUTO_INCREMENT PRIMARY KEY,
    id_voo INT NOT NULL,
    id_aeroporto INT NOT NULL,
    ordem_escala INT NOT NULL,
    horario_saida_previsto DATETIME NOT NULL,
    horario_chegada_previsto DATETIME NOT NULL,
    FOREIGN KEY (id_voo) REFERENCES voos(id_voo),
    FOREIGN KEY (id_aeroporto) REFERENCES aeroportos(id_aeroporto),
    UNIQUE (id_voo, ordem_escala),
    CHECK (horario_chegada_previsto > horario_saida_previsto)
);

-- Tabela de Clientes 
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE,
    email VARCHAR(100),
    telefone VARCHAR(20),
    endereco TEXT,
    cidade VARCHAR(50),
    estado CHAR(2),
    cep VARCHAR(10),
    pais VARCHAR(50),
    -- Campos incorporados da tabela clientes_preferenciais
    nivel_preferencia ENUM('Bronze', 'Prata', 'Ouro', 'Diamante') DEFAULT 'Bronze',
    milhas_accumuladas INT DEFAULT 0,
    data_ultimo_voo DATE,
    frequencia_voos_ano INT DEFAULT 0,
    aceita_mala_direta BOOLEAN DEFAULT TRUE
);

-- Tabela de Reservas
CREATE TABLE reservas (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_config INT NOT NULL,  -- Referência direta à configuração de poltrona no voo
    data_reserva DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Confirmada', 'Cancelada', 'Em espera', 'Check-in realizado') DEFAULT 'Confirmada',
    forma_pagamento ENUM('Cartão Crédito', 'Cartão Débito', 'Boleto', 'Transferência', 'Milhas'),
    valor_total DECIMAL(10,2) NOT NULL,
    preco_poltrona DECIMAL(10,2) NOT NULL,  -- Campo movido de poltronas_reservadas
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_config) REFERENCES config_poltronas_voo(id_config),
    UNIQUE (id_config)  -- Garante que uma poltrona só pode ser reservada uma vez
);

-- Tabela de Histórico de Voos
CREATE TABLE historico_voos (
    id_historico INT AUTO_INCREMENT PRIMARY KEY,
    id_voo INT NOT NULL,
    horario_saida_real DATETIME,
    horario_chegada_real DATETIME,
    tempo_atraso INT COMMENT 'Em minutos',
    motivo_atraso TEXT,
    observacoes TEXT,
    FOREIGN KEY (id_voo) REFERENCES voos(id_voo)
);

-- Tabela de Auditoria de Voos
CREATE TABLE auditoria_voo (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_voo INT NOT NULL,
    status_anterior ENUM('Agendado', 'Embarque', 'Decolado', 'Aterrissado', 'Cancelado', 'Atrasado'),
    status_novo ENUM('Agendado', 'Embarque', 'Decolado', 'Aterrissado', 'Cancelado', 'Atrasado'),
    data_alteracao DATETIME,
    usuario VARCHAR(50),
    FOREIGN KEY (id_voo) REFERENCES voos(id_voo)
);

CREATE TABLE auditoria_reservas (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_reserva INT NOT NULL,
    status_anterior ENUM('Confirmada', 'Cancelada', 'Em espera', 'Check-in realizado'),
    status_novo ENUM('Confirmada', 'Cancelada', 'Em espera', 'Check-in realizado'),
    valor_anterior DECIMAL(10,2),
    valor_novo DECIMAL(10,2),
    data_alteracao DATETIME,
    usuario VARCHAR(50),
    FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva)
);

-- Índices para melhorar performance
CREATE INDEX idx_poltronas_aeronave ON poltronas(id_aeronave);
CREATE INDEX idx_config_poltronas_voo ON config_poltronas_voo(id_voo, disponivel);
CREATE INDEX idx_reservas_cliente ON reservas(id_cliente, data_reserva);
CREATE INDEX idx_reservas_config ON reservas(id_config);
CREATE INDEX idx_voos_rota ON voos(id_rota);
CREATE INDEX idx_voos_aeronave ON voos(id_aeronave);
CREATE INDEX idx_voos_status ON voos(status);
CREATE INDEX idx_rotas_internacionais ON rotas(id_aeroporto_origem, id_aeroporto_destino);
CREATE INDEX idx_clientes_nivel ON clientes(nivel_preferencia, milhas_accumuladas);
CREATE INDEX idx_historico_voo_data ON historico_voos(id_voo, horario_saida_real);
