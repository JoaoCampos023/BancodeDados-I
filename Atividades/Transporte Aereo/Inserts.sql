USE Aeroporto;

-- Inserindo aeroportos
INSERT INTO aeroportos (codigo_iata, nome, cidade, pais, terminal) VALUES
('GRU', 'Aeroporto Internacional de São Paulo/Guarulhos', 'São Paulo', 'Brasil', 'Terminal 1'),
('GIG', 'Aeroporto Internacional do Rio de Janeiro/Galeão', 'Rio de Janeiro', 'Brasil', 'Principal'),
('JFK', 'John F. Kennedy International Airport', 'Nova York', 'Estados Unidos', 'Terminal 4'),
('LAX', 'Los Angeles International Airport', 'Los Angeles', 'Estados Unidos', 'Tom Bradley'),
('CDG', 'Charles de Gaulle Airport', 'Paris', 'França', 'Terminal 2E');

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
('Jato Comercial', 280, 'Airbus', 'A350', 2021);

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
(1, 2),  -- GRU -> GIG
(1, 3),  -- GRU -> JFK
(3, 1),  -- JFK -> GRU
(2, 4),  -- GIG -> LAX
(4, 5);  -- LAX -> CDG

-- Inserindo voos
INSERT INTO voos (numero_voo, id_aeronave, id_rota, horario_saida, horario_chegada_previsto, status) VALUES
('LA1234', 1, 1, '2023-12-01 08:00:00', '2023-12-01 09:30:00', 'Agendado'),
('LA5678', 2, 2, '2023-12-02 22:00:00', '2023-12-03 08:30:00', 'Agendado'),
('LA9012', 3, 3, '2023-12-03 10:00:00', '2023-12-03 23:30:00', 'Agendado'),
('LA3456', 4, 4, '2023-12-04 15:00:00', '2023-12-04 23:00:00', 'Agendado'),
('LA7890', 1, 5, '2023-12-05 12:00:00', '2023-12-06 06:00:00', 'Agendado');

-- Configurando poltronas para voos
INSERT INTO config_poltronas_voo (id_voo, id_poltrona, disponivel) VALUES
(1, 1, TRUE), (1, 2, TRUE), (1, 3, TRUE), (1, 4, TRUE), (1, 5, TRUE),
(1, 6, TRUE), (1, 7, TRUE), (1, 8, TRUE), (1, 9, TRUE), (1, 10, TRUE),
(1, 11, TRUE), (1, 12, TRUE), (1, 13, TRUE), (1, 14, TRUE), (1, 15, TRUE);

-- Inserindo clientes
INSERT INTO clientes (cpf, nome, data_nascimento, email, telefone, endereco, cidade, estado, cep, pais, nivel_preferencia, milhas_accumuladas, data_ultimo_voo, frequencia_voos_ano, aceita_mala_direta) VALUES
('123.456.789-01', 'João Silva', '1980-05-15', 'joao.silva@email.com', '(11) 99999-9999', 'Rua A, 123', 'São Paulo', 'SP', '01000-000', 'Brasil', 'Ouro', 15000, '2023-10-15', 8, TRUE),
('234.567.890-12', 'Maria Oliveira', '1990-08-20', 'maria.oliveira@email.com', '(21) 88888-8888', 'Av B, 456', 'Rio de Janeiro', 'RJ', '20000-000', 'Brasil', 'Prata', 8000, '2023-09-20', 5, TRUE),
('345.678.901-23', 'Carlos Souza', '1975-03-10', 'carlos.souza@email.com', '(31) 77777-7777', 'Rua C, 789', 'Belo Horizonte', 'MG', '30000-000', 'Brasil', 'Bronze', 3000, '2023-08-05', 2, FALSE),
('456.789.012-34', 'Ana Pereira', '1988-11-25', 'ana.pereira@email.com', '(11) 66666-6666', 'Av D, 1011', 'São Paulo', 'SP', '02000-000', 'Brasil', 'Diamante', 30000, '2023-11-10', 15, TRUE),
('567.890.123-45', 'Pedro Costa', '1995-07-30', 'pedro.costa@email.com', '(21) 55555-5555', 'Rua E, 1213', 'Rio de Janeiro', 'RJ', '21000-000', 'Brasil', 'Ouro', 12000, '2023-10-25', 7, TRUE);

-- Inserindo reservas
INSERT INTO reservas (id_cliente, id_config, status, forma_pagamento, valor_total, preco_poltrona) VALUES
(1, 1, 'Confirmada', 'Cartão Crédito', 2500.00, 2500.00),
(2, 7, 'Confirmada', 'Milhas', 1800.00, 1800.00),
(3, 13, 'Em espera', 'Cartão Débito', 800.00, 800.00),
(4, 4, 'Check-in realizado', 'Cartão Crédito', 3000.00, 3000.00),
(5, 10, 'Confirmada', 'Boleto', 1200.00, 1200.00);

-- Inserindo histórico de voos
INSERT INTO historico_voos (id_voo, horario_saida_real, horario_chegada_real, tempo_atraso, motivo_atraso, observacoes) VALUES
(1, '2023-11-01 08:15:00', '2023-11-01 09:40:00', 10, 'Atraso na liberação da pista', 'Voo tranquilo após decolagem'),
(2, '2023-11-02 22:30:00', '2023-11-03 08:45:00', 15, 'Problemas com bagagens', 'Serviço de bordo excelente'),
(3, '2023-11-03 10:00:00', '2023-11-03 23:20:00', 0, NULL, 'Voo pontual, sem ocorrências');