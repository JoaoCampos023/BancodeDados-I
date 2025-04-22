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
('456.789.123-00', 'Beatriz Lima', 'bia@exemplo.com', '(11)93456-7890', 'F', '2000-03-05', 'Organizador'),
('222.333.444-55', 'Alan Turing', 'turing@email.com', '(11) 92345-6789', 'M', '1912-06-23', 'Palestrante'),
('333.444.555-66', 'Ada Lovelace', 'lovelace@email.com', '(21) 93456-7890', 'F', '1815-12-10', 'Organizador'),
('444.555.666-77', 'Marie Curie', 'curie@email.com', '(31) 94567-8901', 'F', '1867-11-07', 'Participante'),
('555.666.777-88', 'Nikola Tesla', 'tesla@email.com', '(41) 95678-9012', 'M', '1856-07-10', 'Palestrante'),
('666.777.888-99', 'Rosalind Franklin', 'franklin@email.com', '(51) 96789-0123', 'F', '1920-07-25', 'Organizador'),
('777.888.999-11', 'Carl Sagan', 'sagan@email.com', '(61) 97890-1234', 'M', '1934-11-09', 'Participante'),
('888.999.000-22', 'Sigmund Freud', 'freud@email.com', '(71) 98901-2345', 'M', '1856-05-06', 'Palestrante'),
('999.000.111-33', 'Charles Darwin', 'darwin@email.com', '(81) 99012-3456', 'M', '1809-02-12', 'Participante'),
('111.222.333-44', 'Stephen Hawking', 'hawking@email.com', '(11) 91234-5678', 'M', '1942-01-08', 'Palestrante'),
('222.444.555-99', 'Katherine Johnson', 'johnson@email.com', '(21) 92345-6789', 'F', '1918-08-26', 'Organizador'),
('333.555.666-88', 'Galileu Galilei', 'galilei@email.com', '(31) 93456-7890', 'M', '1564-02-15', 'Participante'),
('444.666.777-77', 'Isaac Newton', 'newton@email.com', '(41) 94567-8901', 'M', '1643-01-04', 'Palestrante'),
('555.777.888-66', 'Leonhard Euler', 'euler@email.com', '(51) 95678-9012', 'M', '1707-04-15', 'Organizador'),
('666.888.999-55', 'Niels Bohr', 'bohr@email.com', '(61) 96789-0123', 'M', '1885-10-07', 'Participante'),
('777.999.000-44', 'Richard Feynman', 'feynman@email.com', '(61) 98765-4321', 'M', '1918-05-11', 'Palestrante'),
('888.000.111-33', 'Alan Kay', 'kay@email.com', '(71) 97654-3210', 'M', '1940-05-17', 'Organizador'),
('999.111.222-22', 'Barbara Liskov', 'liskov@email.com', '(81) 96543-2109', 'F', '1939-11-07', 'Participante'),
('111.333.444-11', 'Claude Shannon', 'shannon@email.com', '(91) 95432-1098', 'M', '1916-04-30', 'Palestrante'),
('222.555.666-00', 'Grace Hopper', 'hopper@email.com', '(11) 94321-0987', 'F', '1906-12-09', 'Organizador'),
('333.666.777-99', 'Linus Torvalds', 'torvalds@email.com', '(21) 93210-9876', 'M', '1969-12-28', 'Participante'),
('444.777.888-88', 'Tim Berners-Lee', 'berners-lee@email.com', '(31) 92109-8765', 'M', '1955-06-08', 'Palestrante'),
('555.888.999-77', 'John von Neumann', 'neumann@email.com', '(41) 91098-7654', 'M', '1903-12-28', 'Organizador'),
('666.999.000-66', 'Donald Knuth', 'knuth@email.com', '(51) 90987-6543', 'M', '1938-01-10', 'Participante'),
('777.000.111-55', 'Edsger Dijkstra', 'dijkstra@email.com', '(61) 89876-5432', 'M', '1930-05-11', 'Palestrante');

-- Universitário associado à primeira pessoa
INSERT INTO Universitario (id_pessoa, codigo_universitario)
VALUES 
(1, 2023001),
(2, 2023002),
(3, 2023003),
(4, 2023004);

-- Inserir tema
INSERT INTO Tema (nome, descricao, area_conhecimento)
VALUES 
('Inteligência Artificial', 'Estudos sobre algoritmos de IA', 'Computação'),
('Banco de Dados', 'Estudo de SGBDs', 'Computação'),
('Redes', 'Infraestrutura de redes', 'Computação'),
('Compiladores', 'Processamento de Linguagens', 'Computação'),
('Inteligência Artificial', 'Estudo de redes neurais e aprendizado de máquina', 'Computação'),
('Cibersegurança', 'Técnicas de proteção e mitigação de ataques', 'Computação'),
('Biologia Molecular', 'Estudo da estrutura e função dos genes', 'Biociências'),
('Astronomia', 'Exploração de corpos celestes e cosmologia', 'Ciências Exatas'),
('Psicologia Cognitiva', 'Compreensão da mente humana e processos de pensamento', 'Ciências Humanas'),
('Física Quântica', 'Estudo do comportamento de partículas subatômicas', 'Física'),
('Matemática Pura', 'Teorias matemáticas abstratas', 'Matemática'),
('Engenharia Aeroespacial', 'Projetos e desenvolvimento de aeronaves e espaçonaves', 'Engenharia'),
('Computação Quântica', 'Uso de princípios quânticos para computação', 'Computação'),
('Ciência de Dados', 'Análise de grandes volumes de dados para extração de conhecimento', 'Computação'),
('Desenvolvimento de Jogos', 'Criação de jogos digitais e motores gráficos', 'Computação'),
('Robótica', 'Desenvolvimento de robôs e sistemas automatizados', 'Engenharia'),
('Nanotecnologia', 'Manipulação da matéria em escala nanométrica', 'Engenharia'),
('Filosofia da Mente', 'Estudos sobre consciência, percepção e identidade', 'Ciências Humanas'),
('Sociologia Digital', 'Impactos das tecnologias na sociedade contemporânea', 'Ciências Humanas'),
('Ecologia Urbana', 'Interações entre organismos e ambiente em áreas urbanas', 'Biociências'),
('Neurociência', 'Estudo do sistema nervoso e do cérebro', 'Biociências'),
('Matemática Aplicada', 'Aplicações práticas de conceitos matemáticos em engenharia e ciências', 'Matemática'),
('Astrofísica', 'Estudo físico de corpos celestes e fenômenos cósmicos', 'Física'),
('Energias Renováveis', 'Fontes de energia sustentáveis como solar, eólica e biomassa', 'Engenharia Ambiental'),
('Mudanças Climáticas', 'Análise das alterações climáticas e seus impactos ambientais', 'Ciências Ambientais');

-- Comissão ligada ao tema
INSERT INTO Comissao (nome, id_tema, descricao)
VALUES 
('Comissão de IA', 1, 'Organizadores de eventos de IA'),
('Comissão de Banco de Dados', 1, 'Responsável por artigos sobre Banco de Dados'),
('Comissão de Redes', 2, 'Responsável por artigos sobre Redes'),
('Comissão de Compiladores', 3, 'Responsável por artigos sobre compiladores'),
('Comissão de Inteligência Artificial', 4, 'Avanços em IA'),
('Comissão de Cibersegurança', 5, 'Segurança da Informação e proteção de dados'),
('Comissão de Biologia Molecular', 6, 'Pesquisas em DNA e genética'),
('Comissão de Astronomia', 7, 'Estudos sobre o universo e astrofísica'),
('Comissão de Psicologia Cognitiva', 8, 'Pesquisa em comportamento e cognição'),
('Comissão de Física Quântica', 9, 'Pesquisas em mecânica quântica'),
('Comissão de Matemática Pura', 10, 'Avanços matemáticos'),
('Comissão de Engenharia Aeroespacial', 11, 'Projetos de aeronaves e foguetes'),
('Comissão de Computação Quântica', 12, 'Aplicações e algoritmos em computação quântica'),
('Comissão de Ciência de Dados', 13, 'Análise, mineração e visualização de dados'),
('Comissão de Desenvolvimento de Jogos', 14, 'Design, mecânica e inteligência em jogos digitais'),
('Comissão de Robótica', 15, 'Sistemas robóticos e automação inteligente'),
('Comissão de Nanotecnologia', 16, 'Inovações em nanociência e engenharia molecular'),
('Comissão de Filosofia da Mente', 17, 'Discussões sobre consciência, mente e identidade'),
('Comissão de Sociologia Digital', 18, 'Estudos sociais na era digital'),
('Comissão de Ecologia Urbana', 19, 'Soluções ecológicas para ambientes urbanos'),
('Comissão de Neurociência', 20, 'Estudos avançados do cérebro e sistema nervoso'),
('Comissão de Matemática Aplicada', 21, 'Modelagens e aplicações em diversas áreas'),
('Comissão de Astrofísica', 22, 'Fenômenos cósmicos e evolução do universo'),
('Comissão de Energias Renováveis', 23, 'Fontes limpas de energia e sustentabilidade'),
('Comissão de Mudanças Climáticas', 24, 'Impactos e políticas ambientais globais');

-- Minicurso com orador (Carlos) e comissão criada
INSERT INTO Minicurso (titulo, data_evento, hora_inicio, hora_fim, id_orador, id_comissao)
VALUES 
('Introdução ao Machine Learning', '2025-05-10', '09:00:00', '12:00:00', 2, 1),
('Introdução ao MySQL', '2025-06-10', '10:00:00', '12:00:00', 2, 1),
('Redes Avançadas', '2025-06-12', '14:00:00', '16:00:00', 2, 2),
('Fundamentos de IA', '2025-06-14', '09:00:00', '11:00:00', 5, 3),
('Proteção contra Ataques Cibernéticos', '2025-06-15', '13:00:00', '15:00:00', 6, 4),
('Descobrindo o DNA', '2025-06-16', '14:00:00', '16:00:00', 7, 5),
('Exploração Espacial', '2025-06-17', '10:00:00', '12:00:00', 8, 6),
('Psicologia e Tecnologia', '2025-06-18', '08:00:00', '10:00:00', 9, 7),
('Introdução à Física Quântica', '2025-06-19', '10:00:00', '12:00:00', 25, 9),
('Topologia e Geometria', '2025-06-20', '14:00:00', '16:00:00', 26, 10),
('Exploração Espacial Avançada', '2025-06-21', '09:00:00', '11:00:00', 27, 11);

-- Conferência principal
INSERT INTO conferencia (nome, descricao, universidade, data_inicio, data_fim, id_orador_principal, local_conferencia, capacidade)
VALUES ('ConfTech 2025', 'Maior conferência de tecnologia do ano', 'UFTech', '2025-05-10', '2025-05-15', 2, 'Auditório Central', 300);

-- Associação entre o minicurso e a conferência
INSERT INTO Minicurso_conferencia (id_conferencia, id_minicurso)
VALUES (1, 1);

-- Participante inscrito no minicurso
INSERT INTO Inscricao_Minicurso (id_pessoa, id_minicurso)
VALUES (1, 1);

SELECT * FROM pessoa;
SELECT * FROM Universitario;
SELECT * FROM Tema;