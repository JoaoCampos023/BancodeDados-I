USE consultorio_medico;

-- Inserindo especialidades médicas
INSERT INTO especialidades (nome, descricao) VALUES
('Cardiologia', 'Especialidade médica que trata do coração e sistema cardiovascular'),
('Dermatologia', 'Especialidade médica que trata da pele e seus anexos'),
('Ginecologia', 'Especialidade médica que trata da saúde da mulher'),
('Ortopedia', 'Especialidade médica que trata do sistema musculoesquelético'),
('Pediatria', 'Especialidade médica que trata de crianças e adolescentes');

-- Inserindo médicos
INSERT INTO medicos (nome, crm, id_especialidade, telefone, email) VALUES
('Dr. Carlos Silva', 'CRM/SP 123456', 1, '(11) 9999-8888', 'carlos.silva@email.com'),
('Dra. Ana Oliveira', 'CRM/SP 654321', 2, '(11) 9888-7777', 'ana.oliveira@email.com'),
('Dr. Marcos Souza', 'CRM/SP 789012', 3, '(11) 9777-6666', 'marcos.souza@email.com'),
('Dra. Juliana Costa', 'CRM/SP 345678', 4, '(11) 9666-5555', 'juliana.costa@email.com'),
('Dr. Roberto Almeida', 'CRM/SP 901234', 5, '(11) 9555-4444', 'roberto.almeida@email.com');

-- Inserindo convênios
INSERT INTO convenios (nome, registro_ans) VALUES
('Amil', '123456'),
('Unimed', '654321'),
('Bradesco Saúde', '789012'),
('SulAmérica', '345678'),
('NotreDame Intermédica', '901234');

-- Inserindo pacientes
INSERT INTO pacientes (numero_paciente, nome, data_nascimento, sexo, estado_civil, rg, telefone, email) VALUES
('PAC001', 'Maria Santos', '1985-05-15', 'Feminino', 'Casada', '12.345.678-9', '(11) 9999-1111', 'maria.santos@email.com'),
('PAC002', 'João Pereira', '1990-08-22', 'Masculino', 'Solteiro', '23.456.789-0', '(11) 9888-2222', 'joao.pereira@email.com'),
('PAC003', 'Ana Costa', '1978-03-10', 'Feminino', 'Divorciada', '34.567.890-1', '(11) 9777-3333', 'ana.costa@email.com'),
('PAC004', 'Pedro Oliveira', '1995-11-28', 'Masculino', 'Solteiro', '45.678.901-2', '(11) 9666-4444', 'pedro.oliveira@email.com'),
('PAC005', 'Carla Mendes', '1982-07-17', 'Feminino', 'Casada', '56.789.012-3', '(11) 9555-5555', 'carla.mendes@email.com'),
('PAC006', 'Luiz Souza', '1970-09-30', 'Masculino', 'Viúvo', '67.890.123-4', '(11) 9444-6666', 'luiz.souza@email.com'),
('PAC007', 'Fernanda Lima', '1992-04-05', 'Feminino', 'Solteira', '78.901.234-5', '(11) 9333-7777', 'fernanda.lima@email.com'),
('PAC008', 'Ricardo Alves', '1988-12-12', 'Masculino', 'Casado', '89.012.345-6', '(11) 9222-8888', 'ricardo.alves@email.com'),
('PAC009', 'Patrícia Gomes', '1975-06-25', 'Feminino', 'Divorciada', '90.123.456-7', '(11) 9111-9999', 'patricia.gomes@email.com'),
('PAC010', 'Marcos Ribeiro', '1998-02-18', 'Masculino', 'Solteiro', '01.234.567-8', '(11) 9000-0000', 'marcos.ribeiro@email.com');

-- Inserindo relacionamento paciente-convênio
INSERT INTO paciente_convenio (id_paciente, id_convenio, numero_carteira, data_inicio, ativo) VALUES
(1, 1, 'AMIL12345', '2020-01-15', TRUE),
(2, 2, 'UNI54321', '2019-05-20', TRUE),
(3, 3, 'BRAD78901', '2021-03-10', TRUE),
(4, 4, 'SUL34567', '2020-11-28', TRUE),
(5, 5, 'NOT90123', '2018-07-17', TRUE),
(6, 1, 'AMIL67890', '2019-09-30', FALSE),
(7, 2, 'UNI23456', '2022-04-05', TRUE),
(8, 3, 'BRAD89012', '2020-12-12', TRUE),
(9, 4, 'SUL45678', '2021-06-25', TRUE),
(10, 5, 'NOT01234', '2022-02-18', TRUE);

-- Inserindo tipos de exame
INSERT INTO tipos_exame (nome, descricao, valor_referencia) VALUES
('Hemograma Completo', 'Avaliação das células sanguíneas', 'Variável conforme idade e sexo'),
('Glicemia em Jejum', 'Medição de glicose no sangue', '70-99 mg/dL'),
('Colesterol Total', 'Níveis de colesterol no sangue', '< 200 mg/dL'),
('TSH', 'Avaliação da função tireoidiana', '0,4-4,0 mUI/L'),
('Eletrocardiograma', 'Avaliação da atividade elétrica do coração', 'Padrão específico'),
('Ultrassom Abdominal', 'Avaliação de órgãos abdominais', 'Achados normais'),
('Raio-X de Tórax', 'Avaliação de pulmões e estruturas torácicas', 'Achados normais');

-- Inserindo consultas
INSERT INTO consultas (id_paciente, id_medico, data_consulta, diagnostico, prescricao, status) VALUES
(1, 1, '2023-05-10 09:00:00', 'Hipertensão arterial estágio 1', 'Losartana 50mg 1x/dia', 'Realizada'),
(2, 2, '2023-05-11 10:30:00', 'Dermatite atópica', 'Hidratante corporal e corticóide tópico', 'Realizada'),
(3, 3, '2023-05-12 14:00:00', 'Consulta de rotina', 'Solicitado preventivo', 'Realizada'),
(4, 4, '2023-05-15 11:00:00', 'Lombalgia', 'Anti-inflamatório e fisioterapia', 'Realizada'),
(5, 5, '2023-05-16 08:30:00', 'Resfriado comum', 'Sintomáticos e hidratação', 'Realizada'),
(6, 1, '2023-05-17 15:30:00', 'Arritmia cardíaca', 'Solicitado Holter 24h', 'Realizada'),
(7, 2, '2023-05-18 16:00:00', 'Acne moderada', 'Antibiótico tópico e cuidados com a pele', 'Realizada'),
(8, 3, '2023-05-19 09:30:00', 'Consulta pré-natal', 'Solicitado ultrassom obstétrico', 'Realizada'),
(9, 4, '2023-05-22 10:00:00', 'Artrose de joelho', 'Analgésico e condroprotetor', 'Realizada'),
(10, 5, '2023-05-23 14:30:00', 'Acompanhamento crescimento', 'Orientações nutricionais', 'Realizada'),
(1, 1, '2023-06-10 09:00:00', NULL, NULL, 'Agendada'),
(2, 2, '2023-06-11 10:30:00', NULL, NULL, 'Agendada'),
(3, 3, '2023-06-12 14:00:00', NULL, NULL, 'Agendada');

-- Inserindo exames
INSERT INTO exames (id_consulta, id_tipo_exame, id_paciente, data_solicitacao, data_realizacao, data_resultado, resultado, status) VALUES
(1, 1, 1, '2023-05-10', '2023-05-12', '2023-05-15', 'Hemograma dentro dos parâmetros normais', 'Resultado Disponível'),
(1, 2, 1, '2023-05-10', '2023-05-12', '2023-05-15', 'Glicemia de jejum: 92 mg/dL', 'Resultado Disponível'),
(3, 4, 3, '2023-05-12', '2023-05-14', '2023-05-17', 'TSH: 2.3 mUI/L', 'Resultado Disponível'),
(4, 5, 4, '2023-05-15', '2023-05-16', '2023-05-18', 'Eletrocardiograma sem alterações', 'Resultado Disponível'),
(6, 5, 6, '2023-05-17', '2023-05-19', '2023-05-22', 'Arritmia ventricular ocasional', 'Resultado Disponível'),
(8, 6, 8, '2023-05-19', '2023-05-21', '2023-05-24', 'Ultrassom com feto em desenvolvimento normal', 'Resultado Disponível'),
(9, 7, 9, '2023-05-22', '2023-05-23', NULL, NULL, 'Realizado'),
(2, 1, 2, '2023-05-11', '2023-05-13', '2023-05-16', 'Leucócitos discretamente elevados', 'Resultado Disponível'),
(5, 3, 5, '2023-05-16', '2023-05-18', '2023-05-20', 'Colesterol total: 185 mg/dL', 'Resultado Disponível'),
(7, 2, 7, '2023-05-18', '2023-05-20', '2023-05-23', 'Glicemia de jejum: 85 mg/dL', 'Resultado Disponível');