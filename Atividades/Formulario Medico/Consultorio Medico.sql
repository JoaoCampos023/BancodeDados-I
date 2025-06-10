CREATE DATABASE consultorio_medico;

USE consultorio_medico;

-- Tabela de Pacientes (com e-mail adicionado)
CREATE TABLE pacientes (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    numero_paciente VARCHAR(20) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    sexo ENUM('Masculino', 'Feminino', 'Outro') NOT NULL,
    estado_civil VARCHAR(30),
    rg VARCHAR(20),
    telefone VARCHAR(20),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabela de Convênios (com registro ANS adicionado)
CREATE TABLE convenios (
    id_convenio INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    registro_ans VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Relacionamento Paciente-Convênio
CREATE TABLE paciente_convenio (
    id_paciente_convenio INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_convenio INT NOT NULL,
    numero_carteira VARCHAR(50),
    data_inicio DATE,
    data_fim DATE,
    ativo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    FOREIGN KEY (id_convenio) REFERENCES convenios(id_convenio),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY (id_paciente, id_convenio, numero_carteira)
);

-- Tabela de Médicos (com especialidade como tabela separada)
CREATE TABLE especialidades (
    id_especialidade INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

CREATE TABLE medicos (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    crm VARCHAR(20) NOT NULL UNIQUE,
    id_especialidade INT,
    telefone VARCHAR(20),
    email VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_especialidade) REFERENCES especialidades(id_especialidade)
);

-- Tabela de Consultas (com status adicionado)
CREATE TABLE consultas (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    data_consulta DATETIME NOT NULL,
    diagnostico TEXT,
    prescricao TEXT,
    observacoes TEXT,
    status ENUM('Agendada', 'Realizada', 'Cancelada', 'Falta') DEFAULT 'Agendada',
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES medicos(id_medico),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX (data_consulta)
);

-- Tabela de Tipos de Exame (com valor de referência)
CREATE TABLE tipos_exame (
    id_tipo_exame INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    valor_referencia TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Exames (com status adicionado)
CREATE TABLE exames (
    id_exame INT AUTO_INCREMENT PRIMARY KEY,
    id_consulta INT,
    id_tipo_exame INT NOT NULL,
    id_paciente INT NOT NULL,
    data_solicitacao DATE NOT NULL,
    data_realizacao DATE,
    data_resultado DATE,
    resultado TEXT,
    laboratorio VARCHAR(100),
    status ENUM('Solicitado', 'Realizado', 'Cancelado', 'Resultado Disponível') DEFAULT 'Solicitado',
    FOREIGN KEY (id_consulta) REFERENCES consultas(id_consulta),
    FOREIGN KEY (id_tipo_exame) REFERENCES tipos_exame(id_tipo_exame),
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);