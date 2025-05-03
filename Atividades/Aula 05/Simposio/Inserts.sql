USE Simposio;

-- Inserções na tabela Pessoa
INSERT INTO Pessoa (cpf, nome_completo, email, telefone, sexo, data_nascimento, tipo_pessoa, eh_universitario, cod_universitario) VALUES
('12345678901', 'João Silva', 'joao.silva@email.com', '11987654321', 'M', '1990-05-15', 'Participante', TRUE, 1001),
('23456789012', 'Maria Oliveira', 'maria.oliveira@email.com', '21987654322', 'F', '1985-08-20', 'Palestrante', TRUE, 1002),
('34567890123', 'Carlos Pereira', 'carlos.pereira@email.com', '31987654323', 'M', '1992-03-10', 'Organizador', TRUE, 1003),
('45678901234', 'Ana Santos', 'ana.santos@email.com', '41987654324', 'F', '1988-11-25', 'Participante', FALSE, NULL),
('56789012345', 'Pedro Costa', 'pedro.costa@email.com', '51987654325', 'M', '1995-07-30', 'Palestrante', TRUE, 1005),
('67890123456', 'Juliana Almeida', 'juliana.almeida@email.com', '61987654326', 'F', '1991-09-12', 'Participante', TRUE, 1006),
('78901234567', 'Marcos Souza', 'marcos.souza@email.com', '71987654327', 'M', '1987-04-05', 'Organizador', FALSE, NULL),
('89012345678', 'Fernanda Lima', 'fernanda.lima@email.com', '81987654328', 'F', '1993-12-18', 'Palestrante', TRUE, 1008),
('90123456789', 'Ricardo Martins', 'ricardo.martins@email.com', '91987654329', 'M', '1989-06-22', 'Participante', FALSE, NULL),
('01234567890', 'Patrícia Rocha', 'patricia.rocha@email.com', '11987654330', 'F', '1994-02-28', 'Organizador', TRUE, 1010),
('11223344556', 'Luiz Fernandes', 'luiz.fernandes@email.com', '11987654331', 'M', '1991-04-18', 'Participante', TRUE, 1011),
('22334455667', 'Beatriz Castro', 'beatriz.castro@email.com', '21987654332', 'F', '1986-07-23', 'Palestrante', TRUE, 1012),
('33445566778', 'Gustavo Henrique', 'gustavo.henrique@email.com', '31987654333', 'M', '1993-01-11', 'Organizador', TRUE, 1013),
('44556677889', 'Daniela Menezes', 'daniela.menezes@email.com', '41987654334', 'F', '1989-10-26', 'Participante', FALSE, NULL),
('55667788990', 'Roberto Alves', 'roberto.alves@email.com', '51987654335', 'M', '1996-06-01', 'Palestrante', TRUE, 1015),
('66778899001', 'Camila Ribeiro', 'camila.ribeiro@email.com', '61987654336', 'F', '1992-08-13', 'Participante', TRUE, 1016),
('77889900112', 'Eduardo Nunes', 'eduardo.nunes@email.com', '71987654337', 'M', '1988-03-06', 'Organizador', FALSE, NULL),
('88990011223', 'Tatiana Soares', 'tatiana.soares@email.com', '81987654338', 'F', '1994-11-19', 'Palestrante', TRUE, 1018),
('99001112234', 'Leonardo Campos', 'leonardo.campos@email.com', '91987654339', 'M', '1990-05-23', 'Participante', FALSE, NULL),
('00112233445', 'Vanessa Dias', 'vanessa.dias@email.com', '11987654340', 'F', '1995-01-29', 'Organizador', TRUE, 1020);

-- Inserçoes na tabela tema
INSERT INTO Tema (nome, descricao, area_conhecimento) VALUES
('Inteligência Artificial', 'Técnicas avançadas de IA e machine learning', 'Ciência da Computação'),
('Biologia Molecular', 'Pesquisas em genética e biologia celular', 'Biologia'),
('Economia Sustentável', 'Modelos econômicos para desenvolvimento sustentável', 'Economia'),
('Educação Inclusiva', 'Métodos pedagógicos para inclusão social', 'Educação'),
('Energias Renováveis', 'Tecnologias para geração de energia limpa', 'Engenharia'),
('Blockchain', 'Tecnologias de ledger distribuído e criptomoedas', 'Ciência da Computação'),
('Ecologia Marinha', 'Estudos sobre ecossistemas oceânicos', 'Biologia'),
('Mercado de Capitais', 'Análise de investimentos e bolsas de valores', 'Economia'),
('Educação Digital', 'Tecnologias aplicadas ao ensino remoto', 'Educação'),
('Energia Nuclear', 'Tecnologias para geração de energia nuclear segura', 'Engenharia');

-- Inserções na tabela Comissao
INSERT INTO Comissao (nome, id_tema, descricao) VALUES
('Comissão de Tecnologia', 1, 'Avalia trabalhos na área de tecnologia'),
('Comissão de Biociências', 2, 'Avalia trabalhos na área de biologia'),
('Comissão de Humanidades', 4, 'Avalia trabalhos na área de educação'),
('Comissão de Engenharia', 5, 'Avalia trabalhos na área de engenharia'),
('Comissão de Economia', 3, 'Avalia trabalhos na área econômica'),
('Comissão de Inovação', 6, 'Avalia trabalhos na área de tecnologias disruptivas'),
('Comissão de Ciências do Mar', 7, 'Avalia trabalhos na área de oceanografia'),
('Comissão de Tecnologia Educacional', 9, 'Avalia trabalhos na área de educação digital'),
('Comissão de Energia', 10, 'Avalia trabalhos na área de energia nuclear'),
('Comissão de Finanças', 8, 'Avalia trabalhos na área de mercado financeiro');

-- Inserções na tabela Simposio
INSERT INTO Simposio (titulo, descricao, universidade, data_inicio, data_fim, id_orador_principal, local_simposio, capacidade) VALUES
('Simpósio de Tecnologia 2023', 'Evento sobre as últimas tendências em TI', 'Universidade Federal de Tecnologia', '2023-11-15', '2023-11-18', 2, 'Centro de Convenções da Cidade', 500),
('Simpósio de Ciências Biológicas', 'Discussões sobre avanços em biologia', 'Universidade de Biociências', '2023-10-20', '2023-10-22', 5, 'Campus Universitário - Bloco B', 300),
('Fórum de Educação Moderna', 'Debates sobre metodologias de ensino', 'Faculdade de Educação', '2023-09-05', '2023-09-07', 8, 'Auditório Principal', 200),
('Simpósio de Inovação 2023', 'Evento sobre tecnologias disruptivas', 'Universidade Federal de Inovação', '2023-12-10', '2023-12-13', 12, 'Centro de Eventos Tecnológicos', 600),
('Simpósio de Ciências do Mar', 'Discussões sobre oceanos e vida marinha', 'Universidade de Oceanografia', '2023-11-25', '2023-11-27', 15, 'Campus Costeiro - Auditório Azul', 350),
('Fórum de Educação Digital', 'Debates sobre o futuro do ensino online', 'Faculdade de Tecnologia Educacional', '2023-10-15', '2023-10-17', 18, 'Auditório Virtual', 250);

-- Inserções na tabela Minicurso
INSERT INTO Minicurso (titulo, data_evento, hora_inicio, hora_fim, id_tema) VALUES
('Introdução ao Deep Learning', '2023-11-16', '09:00:00', '12:00:00', 1),
('Técnicas de PCR Avançada', '2023-10-21', '14:00:00', '17:00:00', 2),
('Metodologias Ativas de Aprendizagem', '2023-09-06', '10:00:00', '13:00:00', 4),
('Introdução ao Blockchain', '2023-12-11', '10:00:00', '13:00:00', 6),
('Técnicas de Monitoramento Marinho', '2023-11-26', '15:00:00', '18:00:00', 7),
('Plataformas de EAD', '2023-10-16', '11:00:00', '14:00:00', 9);

-- Inserções na tabela Palestra
INSERT INTO Palestra (titulo, data_evento, hora_inicio, hora_fim, id_tema) VALUES
('O Futuro da IA Generativa', '2023-11-17', '14:00:00', '16:00:00', 1),
('Descobertas em Genômica', '2023-10-22', '09:00:00', '11:00:00', 2),
('Educação Pós-Pandemia', '2023-09-07', '16:00:00', '18:00:00', 4),
('O Futuro das Criptomoedas', '2023-12-12', '15:00:00', '17:00:00', 6),
('Descobertas em Recifes de Coral', '2023-11-27', '10:00:00', '12:00:00', 7),
('Gamificação na Educação', '2023-10-17', '17:00:00', '19:00:00', 9);

-- Inserções na tabela Artigo
-- Artigo 1: Comissão 1 (Tema 1 - Inteligência Artificial)
INSERT INTO Artigo (avaliacao, titulo, data_submissao, data_avaliacao, nota_avaliacao, id_comissao, id_tema) VALUES
('Aprovado', 'Redes Neurais para Processamento de Linguagem Natural', '2023-08-10', '2023-09-01', 8, 1, 1);

-- Artigo 2: Comissão 2 (Tema 2 - Biologia Molecular)
INSERT INTO Artigo (avaliacao, titulo, data_submissao, data_avaliacao, nota_avaliacao, id_comissao, id_tema) VALUES
('Reprovado', 'Análise de Mutação Genética em Drosophila', '2023-07-15', '2023-08-01', 5, 2, 2);

-- Artigo 3: Comissão 3 (Tema 4 - Educação Inclusiva)
INSERT INTO Artigo (avaliacao, titulo, data_submissao, data_avaliacao, nota_avaliacao, id_comissao, id_tema) VALUES
('Aprovado', 'Modelos de Aprendizagem Baseada em Projetos', '2023-06-20', '2023-07-10', 9, 3, 4);

-- Artigo 4: Comissão 6 (Tema 6 - Blockchain)
INSERT INTO Artigo (avaliacao, titulo, data_submissao, data_avaliacao, nota_avaliacao, id_comissao, id_tema) VALUES
('Aprovado', 'Contratos Inteligentes em Ethereum', '2023-09-15', '2023-10-01', 9, 6, 6);

-- Artigo 5: Comissão 7 (Tema 7 - Ecologia Marinha)
INSERT INTO Artigo (avaliacao, titulo, data_submissao, data_avaliacao, nota_avaliacao, id_comissao, id_tema) VALUES
('Reprovado', 'Impacto do Aquecimento Global nos Oceanos', '2023-08-20', '2023-09-05', 4, 7, 7);

-- Artigo 6: Comissão 9 (Tema 9 - Educação Digital)
INSERT INTO Artigo (avaliacao, titulo, data_submissao, data_avaliacao, nota_avaliacao, id_comissao, id_tema) VALUES
('Aprovado', 'Eficácia das Plataformas de Videoconferência', '2023-07-25', '2023-08-15', 8, 9, 10);

-- Inserções nas tabelas de relacionamento
INSERT INTO Comissao_Pessoa (id_pessoa, id_comissao) VALUES
(3, 1),
(7, 2),
(10, 3),
(13, 6),
(17, 7),
(20, 9);

INSERT INTO Inscrito_Simposio (id_evento, id_pessoa) VALUES
(1, 1),
(1, 4),
(2, 6),
(3, 9),
(4, 11),
(4, 14),
(5, 16),
(6, 19);

INSERT INTO Minicurso_Simposio (id_simposio, id_minicurso) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6);

INSERT INTO Artigo_Simposio (id_simposio, id_artigo) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6);

INSERT INTO Palestra_Simposio (id_simposio, id_palestra) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6);

INSERT INTO Organizador_Simposio (id_pessoa, id_simposio) VALUES
(3, 1),
(7, 2),
(10, 3),
(13, 4),
(17, 5),
(20, 6);

INSERT INTO Autor_Artigo (id_pessoa, id_artigo) VALUES
(1, 1),
(6, 2),
(9, 3),
(11, 4),
(16, 5),
(19, 6);

INSERT INTO Inscricao_Minicurso (id_pessoa, id_minicurso) VALUES
(1, 1),
(4, 1),
(6, 2),
(9, 3),
(11, 4),
(14, 4),
(16, 5),
(19, 6);

INSERT INTO Inscricao_Palestra (id_pessoa, id_palestra) VALUES
(1, 1),
(4, 1),
(6, 2),
(9, 3),
(11, 4),
(14, 4),
(16, 5),
(19, 6);

INSERT INTO Orador_Minicurso (id_minicurso, id_pessoa) VALUES
(1, 2),
(2, 5),
(3, 8),
(4, 12),
(5, 15),
(6, 18);

INSERT INTO Orador_Palestra (id_palestra, id_pessoa) VALUES
(1, 2),
(2, 5),
(3, 8),
(4, 12),
(5, 15),
(6, 18);