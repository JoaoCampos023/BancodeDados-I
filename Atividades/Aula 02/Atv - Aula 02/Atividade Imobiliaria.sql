-- Criar o banco de dados
CREATE DATABASE Imobiliaria;
USE Imobiliaria;

-- Criar a tabela Imovel
CREATE TABLE Imovel (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome CHAR(100) NOT NULL,
    descricao TEXT,
    numero_quartos INT NOT NULL,
    valor_venda FLOAT NOT NULL
);

-- Inserir 10 registros na tabela Imovel
INSERT INTO Imovel (nome, descricao, numero_quartos, valor_venda) VALUES
('Apartamento Luxo', 'Apartamento de alto padrão no centro da cidade.', 3, 750000.00),
('Casa de Praia', 'Casa aconchegante à beira-mar.', 4, 1200000.00),
('Cobertura Moderna', 'Cobertura duplex com vista panorâmica.', 5, 2000000.00),
('Kitnet Compacta', 'Ideal para estudantes, localizada perto da universidade.', 1, 150000.00),
('Sobrado Familiar', 'Casa espaçosa com quintal e garagem.', 3, 500000.00),
('Chácara Relaxante', 'Propriedade rural com muito verde e lago.', 6, 850000.00),
('Studio Urbano', 'Espaço moderno e compacto para profissionais.', 1, 220000.00),
('Mansão dos Sonhos', 'Mansão de luxo com piscina e salão de festas.', 7, 5000000.00),
('Apartamento Simples', 'Apartamento acessível próximo a transporte público.', 2, 250000.00),
('Casa no Campo', 'Casa charmosa com lareira e vista para as montanhas.', 4, 680000.00);

-- Consulta 1: Selecionar todos os imóveis
SELECT * FROM Imovel;

-- Consulta 2: Selecionar imóveis com mais de 3 quartos
SELECT * FROM Imovel WHERE numero_quartos > 3;

-- Consulta 3: Ordenar imóveis pelo valor de venda de forma decrescente
SELECT * FROM Imovel ORDER BY valor_venda DESC;
