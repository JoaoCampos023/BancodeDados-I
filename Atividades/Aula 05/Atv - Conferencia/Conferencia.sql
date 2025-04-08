CREATE DATABASE IF NOT EXISTS Atvconferencia;

USE Atvconferencia;

CREATE TABLE Pessoa(
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	cpf VARCHAR(14) NOT NULL UNIQUE,
	nome_completo VARCHAR(200) NOT NULL,
	email VARCHAR(200) NOT NULL UNIQUE,
	telefone VARCHAR(15) NOT NULL UNIQUE,
	sexo ENUM('M','F') NOT NULL,
	data_nascimento DATE NOT NULL, 
	tipo_pessoa ENUM('Participante', 'Palestrante', 'Organizador', 'Indefinido') DEFAULT 'Indefinido' NOT NULL 
);

CREATE TABLE Universitario (
	id_pessoa INT NOT NULL PRIMARY KEY,
	codigo_universitario INT NOT NULL UNIQUE,
	CONSTRAINT Fk_universitario_pessoa FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id)
);

CREATE TABLE Tema(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nome VARCHAR(200) NOT NULL,
	descricao TEXT NOT NULL,
	area_conhecimento VARCHAR(200) NOT NULL, 
	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Comissao(
	id  INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nome VARCHAR(200) NOT NULL,
	id_tema INT NOT NULL,
	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	descricao TEXT,
	CONSTRAINT Fk_comissao_tema FOREIGN KEY (id_tema) REFERENCES Tema(id)
);

CREATE TABLE Minicurso(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	titulo VARCHAR(200) NOT NULL,
	data_evento DATE NOT NULL,
	hora_inicio TIME NOT NULL,
	hora_fim TIME NOT NULL,
	id_orador INT NOT NULL,
	id_comissao  INT NOT NULL,
	CONSTRAINT Fk_orador_minicurso FOREIGN KEY (id_orador) REFERENCES Pessoa(id),
	CONSTRAINT Fk_minicurso_comissao FOREIGN KEY (id_comissao) REFERENCES Comissao(id)
);

CREATE TABLE Artigo(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	avaliacao VARCHAR(200) NOT NULL,
	titulo VARCHAR(200) NOT NULL,
	data_submissao DATE NOT NULL,
	data_avaliacao DATE,
	nota_avaliacao INT NOT NULL,
	id_comissao  INT NOT NULL,
	CONSTRAINT Fk_artigo_comissao FOREIGN KEY (id_comissao) REFERENCES Comissao(id)
);

CREATE TABLE Palestra(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	titulo VARCHAR(200) NOT NULL,
	data_evento DATE NOT NULL,
	hora_inicio TIME NOT NULL,
	hora_fim TIME NOT NULL,
	id_orador INT NOT NULL,
	id_comissao  INT NOT NULL,
	CONSTRAINT Fk_orador_palestra FOREIGN KEY (id_orador) REFERENCES Pessoa(id),
	CONSTRAINT Fk_palestra_comissao FOREIGN KEY (id_comissao) REFERENCES Comissao(id)
);

CREATE TABLE conferencia(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nome VARCHAR(200) NOT NULL,
	descricao TEXT,
	universidade VARCHAR(200) NOT NULL,
	data_inicio DATE NOT NULL,
	data_fim DATE NOT NULL,
	id_orador_principal INT NOT NULL,
	local_conferencia VARCHAR(200) NOT NULL,
	capacidade INT,
	CONSTRAINT Fk_orador_conferencia FOREIGN KEY (id_orador_principal) REFERENCES Pessoa(id)
);

-- Tabelas de Relacionamentos
CREATE TABLE Comissao_Pessoa(
	id_pessoa INT NOT NULL,
	id_comissao  INT NOT NULL,
	PRIMARY KEY (id_pessoa, id_comissao),
	CONSTRAINT Fk_comissao_id_pessoa FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id),
	CONSTRAINT Fk_comissao_id_comissao FOREIGN KEY (id_comissao) REFERENCES Comissao(id)
);

CREATE TABLE Inscrito_Pessoa(
	id_evento INT NOT NULL,
	id_pessoa INT NOT NULL,
	PRIMARY KEY (id_pessoa, id_evento),
	CONSTRAINT Fk_inscrito_pessoa FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id),
	CONSTRAINT Fk_inscrito_conferencia FOREIGN KEY (id_evento) REFERENCES conferencia(id)
);

CREATE TABLE Minicurso_conferencia(
	id_conferencia INT NOT NULL,
	id_minicurso INT NOT NULL,
	PRIMARY KEY (id_conferencia, id_minicurso),
	CONSTRAINT Fk_minicurso_conferencia FOREIGN KEY (id_conferencia) REFERENCES conferencia(id),
	CONSTRAINT Fk_conferencia_minicurso FOREIGN KEY (id_minicurso) REFERENCES Minicurso(id)
);

CREATE TABLE Artigo_conferencia(
	id_conferencia INT NOT NULL,
	id_artigo INT NOT NULL,
	PRIMARY KEY (id_conferencia, id_artigo),
	CONSTRAINT Fk_artigo_conferencia FOREIGN KEY (id_conferencia) REFERENCES conferencia(id),
	CONSTRAINT Fk_conferencia_artigo FOREIGN KEY (id_artigo) REFERENCES Artigo(id)
);

CREATE TABLE Organizador_conferencia (
	id_pessoa INT NOT NULL,
	id_conferencia INT NOT NULL,
	PRIMARY KEY (id_pessoa, id_conferencia),
	CONSTRAINT Fk_organizador_conferencia_pessoa FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id),
	CONSTRAINT Fk_organizador_conferencia_conferencia FOREIGN KEY (id_conferencia) REFERENCES conferencia(id)
);

CREATE TABLE Autor_Artigo(
	id_pessoa INT NOT NULL,
	id_artigo INT NOT NULL,
	PRIMARY KEY (id_pessoa, id_artigo),
	CONSTRAINT Fk_autor_artigo_pessoa FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id),
	CONSTRAINT Fk_autor_artigo_artigo  FOREIGN KEY (id_artigo) REFERENCES Artigo(id)
);

CREATE TABLE Inscricao_Minicurso(
	id_pessoa INT NOT NULL,
	id_minicurso INT NOT NULL,
	PRIMARY KEY (id_pessoa, id_minicurso),
	CONSTRAINT Fk_inscricao_minicurso_pessoa FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id),
	CONSTRAINT Fk_inscricao_minicurso_minicurso FOREIGN KEY (id_minicurso) REFERENCES Minicurso(id)
);

CREATE TABLE Inscricao_Palestra(
	id_pessoa INT NOT NULL,
	id_palestra INT NOT NULL,
	PRIMARY KEY (id_pessoa, id_palestra),
	CONSTRAINT Fk_inscricao_palestra_pessoa FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id),
	CONSTRAINT Fk_inscricao_palestra_palestra FOREIGN KEY (id_palestra) REFERENCES Palestra(id)
);

-- Inserindo pessoas
INSERT INTO Pessoa (cpf, nome_completo, email, telefone, sexo, data_nascimento, tipo_pessoa)
VALUES
('123.456.789-00', 'Ana Clara Silva', 'ana@exemplo.com', '(11)91234-5678', 'F', '1995-06-21', 'Participante'),
('987.654.321-00', 'Carlos Souza', 'carlos@exemplo.com', '(11)99876-5432', 'M', '1988-11-10', 'Palestrante'),
('456.789.123-00', 'Beatriz Lima', 'bia@exemplo.com', '(11)93456-7890', 'F', '2000-03-05', 'Organizador');

-- Universitário associado à primeira pessoa
INSERT INTO Universitario (id_pessoa, codigo_universitario)
VALUES (1, 2023001);

-- Inserir tema
INSERT INTO Tema (nome, descricao, area_conhecimento)
VALUES ('Inteligência Artificial', 'Estudos sobre algoritmos de IA', 'Computação');

-- Comissão ligada ao tema
INSERT INTO Comissao (nome, id_tema, descricao)
VALUES ('Comissão de IA', 1, 'Organizadores de eventos de IA');

-- Minicurso com orador (Carlos) e comissão criada
INSERT INTO Minicurso (titulo, data_evento, hora_inicio, hora_fim, id_orador, id_comissao)
VALUES ('Introdução ao Machine Learning', '2025-05-10', '09:00:00', '12:00:00', 2, 1);

-- Conferência principal
INSERT INTO conferencia (nome, descricao, universidade, data_inicio, data_fim, id_orador_principal, local_conferencia, capacidade)
VALUES ('ConfTech 2025', 'Maior conferência de tecnologia do ano', 'UFTech', '2025-05-10', '2025-05-15', 2, 'Auditório Central', 300);

-- Associação entre o minicurso e a conferência
INSERT INTO Minicurso_conferencia (id_conferencia, id_minicurso)
VALUES (1, 1);

-- Participante inscrito no minicurso
INSERT INTO Inscricao_Minicurso (id_pessoa, id_minicurso)
VALUES (1, 1);