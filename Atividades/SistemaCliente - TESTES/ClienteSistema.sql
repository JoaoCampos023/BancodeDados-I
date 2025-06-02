CREATE DATABASE SistemaClientes;
USE SistemaClientes;

CREATE TABLE Clientes (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Matricula VARCHAR(20) UNIQUE NOT NULL,
    Nome VARCHAR(100) NOT NULL,
    DataNascimento DATE NOT NULL,
    Nacionalidade VARCHAR(50) NOT NULL,
    Sexo ENUM('Masculino', 'Feminino', 'Outro') NOT NULL,
    EstadoCivil ENUM('Solteiro', 'Casado', 'Divorciado', 'Viúvo', 'Separado') NOT NULL,
    RG VARCHAR(20) NOT NULL,
    CPF VARCHAR(14) UNIQUE NOT NULL,
    Endereco TEXT NOT NULL,
    DataAdmissao DATE NOT NULL,
    DataCadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE CargosOcupados (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    ClienteId INT NOT NULL,
    Cargo VARCHAR(100) NOT NULL,
    DataInicio DATE NOT NULL,
    DataFim DATE NULL,
    FOREIGN KEY (ClienteId) REFERENCES Clientes(Id) ON DELETE CASCADE
);

CREATE TABLE Dependentes (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    ClienteId INT NOT NULL,
    Nome VARCHAR(100) NOT NULL,
    Parentesco VARCHAR(50) NOT NULL,
    DataNascimento DATE NOT NULL,
    CPF VARCHAR(14) NULL,
    FOREIGN KEY (ClienteId) REFERENCES Clientes(Id) ON DELETE CASCADE
);