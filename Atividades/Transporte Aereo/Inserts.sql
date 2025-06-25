USE Aeroporto;

-- Inserindo aeroportos
INSERT INTO aeroportos (codigo_iata, nome, cidade, pais, terminal) VALUES
('GRU', 'Aeroporto Internacional de São Paulo/Guarulhos', 'São Paulo', 'Brasil', 'Terminal 1'),
('GIG', 'Aeroporto Internacional do Rio de Janeiro/Galeão', 'Rio de Janeiro', 'Brasil', 'Principal'),
('JFK', 'John F. Kennedy International Airport', 'Nova York', 'Estados Unidos', 'Terminal 4'),
('LAX', 'Los Angeles International Airport', 'Los Angeles', 'Estados Unidos', 'Tom Bradley'),
('CDG', 'Charles de Gaulle Airport', 'Paris', 'França', 'Terminal 2E'),
('MIA', 'Miami International Airport', 'Miami', 'Estados Unidos', 'Central'),
('LHR', 'Heathrow Airport', 'Londres', 'Reino Unido', 'Terminal 5'),
('DXB', 'Dubai International Airport', 'Dubai', 'Emirados Árabes', 'Terminal 3'),
('SYD', 'Sydney Airport', 'Sydney', 'Austrália', 'Internacional'),
('HND', 'Haneda Airport', 'Tóquio', 'Japão', 'Terminal 2');

-- Inserindo classes
INSERT INTO classes (nome, descricao, multiplicador_preco) VALUES
('Econômica', 'Classe padrão com serviços básicos', 1.0),
('Econômica Premium', 'Assentos com mais espaço para as pernas', 1.3),
('Executiva', 'Assentos reclináveis e refeições premium', 2.0),
('Primeira Classe', 'Assentos convertíveis em camas e serviço exclusivo', 3.5);

-- Inserindo aeronaves
INSERT INTO aeronaves (tipo_aeronave, numero_poltronas, fabricante, modelo, ano_fabricacao) VALUES
('Jato Comercial', 180, 'Boeing', '737-800', 2018),
('Jato Comercial', 215, 'Airbus', 'A320', 2019),
('Jato Comercial', 350, 'Boeing', '787 Dreamliner', 2020),
('Jato Comercial', 280, 'Airbus', 'A350', 2021),
('Jato Comercial', 150, 'Embraer', 'E195-E2', 2022),
('Jato Comercial', 406, 'Boeing', '777-300ER', 2021),
('Jato Comercial', 240, 'Airbus', 'A330-900neo', 2023);

-- Inserindo poltronas (exemplo para a primeira aeronave)
INSERT INTO poltronas (id_aeronave, numero_poltrona, localizacao, lado, id_classe) VALUES
(1, '1A', 'Janela', 'Esquerda', 4),
(1, '1B', 'Meio', 'Esquerda', 4),
(1, '1C', 'Corredor', 'Esquerda', 4),
(1, '2A', 'Janela', 'Esquerda', 4),
(1, '2B', 'Meio', 'Esquerda', 4),
(1, '2C', 'Corredor', 'Esquerda', 4),
(1, '10A', 'Janela', 'Esquerda', 3),
(1, '10B', 'Meio', 'Esquerda', 3),
(1, '10C', 'Corredor', 'Esquerda', 3),
(1, '20A', 'Janela', 'Esquerda', 2),
(1, '20B', 'Meio', 'Esquerda', 2),
(1, '20C', 'Corredor', 'Esquerda', 2),
(1, '30A', 'Janela', 'Esquerda', 1),
(1, '30B', 'Meio', 'Esquerda', 1),
(1, '30C', 'Corredor', 'Esquerda', 1);

-- Inserindo rotas
INSERT INTO rotas (id_aeroporto_origem, id_aeroporto_destino) VALUES
(1, 2), 
(1, 3),  
(3, 1),  
(2, 4), 
(4, 5), 
(2, 3), 
(3, 4), 
(5, 1), 
(4, 2),
(3, 10), 
(10, 3),  
(6, 7),   
(7, 6),   
(8, 9),   
(9, 8); 

-- Inserindo voos
INSERT INTO voos (numero_voo, id_aeronave, id_rota, horario_saida, horario_chegada_previsto, status) VALUES
('LA1234', 1, 1, '2023-12-01 08:00:00', '2023-12-01 09:30:00', 'Agendado'),
('LA5678', 2, 2, '2023-12-02 22:00:00', '2023-12-03 08:30:00', 'Agendado'),
('LA9012', 3, 3, '2023-12-03 10:00:00', '2023-12-03 23:30:00', 'Agendado'),
('LA3456', 4, 4, '2023-12-04 15:00:00', '2023-12-04 23:00:00', 'Agendado'),
('LA7890', 1, 5, '2023-12-05 12:00:00', '2023-12-06 06:00:00', 'Agendado'),
('LA2468', 5, 6, '2023-12-06 14:00:00', '2023-12-06 18:30:00', 'Agendado'),
('LA1357', 6, 7, '2023-12-07 09:00:00', '2023-12-07 11:30:00', 'Agendado'),
('LA8024', 7, 8, '2023-12-08 20:00:00', '2023-12-09 09:00:00', 'Agendado'),
('LA6420', 5, 9, '2023-12-09 07:00:00', '2023-12-09 08:15:00', 'Agendado'),
('LA9999', 6, 10, '2023-12-10 14:00:00', '2023-12-11 16:30:00', 'Agendado'),
('LA8888', 7, 11, '2023-12-11 18:00:00', '2023-12-11 20:30:00', 'Agendado'), 
('LA7777', 3, 12, '2023-12-12 09:00:00', '2023-12-12 21:00:00', 'Agendado'),  
('LA6666', 4, 13, '2023-12-13 22:00:00', '2023-12-14 06:00:00', 'Agendado'),  
('LA5555', 5, 14, '2023-12-14 23:00:00', '2023-12-15 18:00:00', 'Agendado'), 
('LA4444', 2, 15, '2023-12-15 20:00:00', '2023-12-16 05:00:00', 'Agendado'); 

-- Configurando poltronas para voos
INSERT INTO config_poltronas_voo (id_voo, id_poltrona, disponivel) VALUES
(1, 1, TRUE), (1, 2, TRUE), (1, 3, TRUE), (1, 4, TRUE), 
(1, 5, TRUE), (1, 6, TRUE), (1, 7, TRUE), (1, 8, TRUE), 
(1, 9, TRUE), (1, 10, TRUE), (1, 11, TRUE), (1, 12, TRUE), 
(1, 13, TRUE), (1, 14, TRUE), (1, 15, TRUE),(10, 1, TRUE),
(10, 2, TRUE), (10, 3, TRUE), (11, 4, TRUE), (11, 5, TRUE), 
(11, 6, TRUE), (12, 7, TRUE), (12, 8, TRUE), (12, 9, TRUE),
(13, 10, TRUE), (13, 11, TRUE), (13, 12, TRUE), (14, 13, TRUE), 
(14, 14, TRUE), (14, 15, TRUE), (15, 1, TRUE), (15, 2, TRUE), (15, 3, TRUE);

-- Inserindo clientes
INSERT INTO clientes (cpf, nome, data_nascimento, email, telefone, endereco, cidade, estado, cep, pais, nivel_preferencia, milhas_accumuladas, data_ultimo_voo, frequencia_voos_ano, aceita_mala_direta) VALUES
('123.456.789-01', 'João Silva', '1980-05-15', 'joao.silva@email.com', '(11) 99999-9999', 'Rua A, 123', 'São Paulo', 'SP', '01000-000', 'Brasil', 'Ouro', 15000, '2023-10-15', 8, TRUE),
('234.567.890-12', 'Maria Oliveira', '1990-08-20', 'maria.oliveira@email.com', '(21) 88888-8888', 'Av B, 456', 'Rio de Janeiro', 'RJ', '20000-000', 'Brasil', 'Prata', 8000, '2023-09-20', 5, TRUE),
('345.678.901-23', 'Carlos Souza', '1975-03-10', 'carlos.souza@email.com', '(31) 77777-7777', 'Rua C, 789', 'Belo Horizonte', 'MG', '30000-000', 'Brasil', 'Bronze', 3000, '2023-08-05', 2, FALSE),
('456.789.012-34', 'Ana Pereira', '1988-11-25', 'ana.pereira@email.com', '(11) 66666-6666', 'Av D, 1011', 'São Paulo', 'SP', '02000-000', 'Brasil', 'Diamante', 30000, '2023-11-10', 15, TRUE),
('567.890.123-45', 'Pedro Costa', '1995-07-30', 'pedro.costa@email.com', '(21) 55555-5555', 'Rua E, 1213', 'Rio de Janeiro', 'RJ', '21000-000', 'Brasil', 'Ouro', 12000, '2023-10-25', 7, TRUE),
('678.901.234-56', 'Fernanda Lima', '1992-04-18', 'fernanda.lima@email.com', '(11) 44444-4444', 'Rua F, 1415', 'São Paulo', 'SP', '03000-000', 'Brasil', 'Prata', 9000, '2023-09-15', 6, TRUE),
('789.012.345-67', 'Ricardo Alves', '1985-11-30', 'ricardo.alves@email.com', '(21) 33333-3333', 'Av G, 1617', 'Rio de Janeiro', 'RJ', '22000-000', 'Brasil', 'Bronze', 4000, '2023-07-22', 3, FALSE),
('890.123.456-78', 'Juliana Santos', '1978-07-12', 'juliana.santos@email.com', '(31) 22222-2222', 'Rua H, 1819', 'Belo Horizonte', 'MG', '31000-000', 'Brasil', 'Ouro', 17000, '2023-11-05', 9, TRUE),
('901.234.567-89', 'Roberto Nunes', '1970-12-05', 'roberto.nunes@email.com', '(11) 11111-1111', 'Av I, 2021', 'São Paulo', 'SP', '04000-000', 'Brasil', 'Diamante', 45000, '2023-11-20', 20, TRUE),
('012.345.678-90', 'Patrícia Rocha', '1983-09-15', 'patricia.rocha@email.com', '(21) 12121-2121', 'Rua J, 2223', 'Rio de Janeiro', 'RJ', '23000-000', 'Brasil', 'Ouro', 22000, '2023-10-30', 12, TRUE),
('123.456.789-00', 'Marcos Ferreira', '1998-02-28', 'marcos.ferreira@email.com', '(31) 13131-3131', 'Av K, 2425', 'Belo Horizonte', 'MG', '32000-000', 'Brasil', 'Prata', 11000, '2023-09-25', 8, FALSE),
('234.567.890-11', 'Camila Duarte', '1987-06-17', 'camila.duarte@email.com', '(11) 14141-4141', 'Rua L, 2627', 'São Paulo', 'SP', '05000-000', 'Brasil', 'Bronze', 5000, '2023-08-18', 4, TRUE);

-- Inserindo reservas
INSERT INTO reservas (id_cliente, id_config, status, forma_pagamento, valor_total, preco_poltrona) VALUES
(1, 1, 'Confirmada', 'Cartão Crédito', 2500.00, 2500.00),
(2, 7, 'Confirmada', 'Milhas', 1800.00, 1800.00),
(3, 13, 'Em espera', 'Cartão Débito', 800.00, 800.00),
(4, 4, 'Check-in realizado', 'Cartão Crédito', 3000.00, 3000.00),
(5, 10, 'Confirmada', 'Boleto', 1200.00, 1200.00),
(9, 16, 'Confirmada', 'Cartão Crédito', 2800.00, 2800.00),
(10, 17, 'Confirmada', 'Milhas', 1900.00, 1900.00),
(11, 18, 'Em espera', 'Cartão Débito', 850.00, 850.00),
(12, 19, 'Check-in realizado', 'Cartão Crédito', 3100.00, 3100.00),
(9, 20, 'Confirmada', 'Boleto', 1250.00, 1250.00);

-- Inserindo histórico de voos
INSERT INTO historico_voos (id_voo, horario_saida_real, horario_chegada_real, tempo_atraso, motivo_atraso, observacoes) VALUES
(1, '2023-11-01 08:15:00', '2023-11-01 09:40:00', 10, 'Atraso na liberação da pista', 'Voo tranquilo após decolagem'),
(2, '2023-11-02 22:30:00', '2023-11-03 08:45:00', 15, 'Problemas com bagagens', 'Serviço de bordo excelente'),
(3, '2023-11-03 10:00:00', '2023-11-03 23:20:00', 0, NULL, 'Voo pontual, sem ocorrências'),
(4, '2023-11-04 15:20:00', '2023-11-04 23:45:00', 20, 'Problemas técnicos', 'Resolvido rapidamente pela equipe'),
(5, '2023-11-05 12:30:00', '2023-11-06 06:15:00', 30, 'Condições climáticas', 'Voo seguro mas com turbulência'),
(6, '2023-11-06 14:05:00', '2023-11-06 18:20:00', 5, 'Embarque atrasado', 'Voo tranquilo e pontual');