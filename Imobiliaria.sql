CREATE DATABASE Imobiliaria

USE Imobiliaria

SET DATEFORMAT dmy

CREATE TABLE Imoveis(
	idImovel INT NOT NULL IDENTITY,
	descricao VARCHAR(30) NOT NULL,
	quantQuartos INT NOT NULL,
	tipoImovel CHAR(4) NOT NULL,
	tipoNegocio CHAR(6) NOT NULL,
	valor NUMERIC (9,2) NOT NULL,

	PRIMARY KEY (IdImovel),
	CHECK (tipoImovel IN ('Casa','Apto','Sala')),
	CHECK(tipoNegocio IN ('Vender','Alugar'))
)

CREATE TABLE Enderecos(
	idImovel INT NOT NULL,
	rua VARCHAR (30) NOT NULL,
	numero INT NOT NULL,
	bairro VARCHAR (20) NOT NULL,
	
	PRIMARY KEY (idImovel),
	FOREIGN KEY (idImovel) REFERENCES Imoveis
)

CREATE TABLE Contratos(
	idContrato INT NOT NULL IDENTITY,
	idImovel INT NOT NULL,
	nome VARCHAR (60),
	data DATETIME NOT NULL,
	formaPagamento VARCHAR(15) NOT NULL,

	PRIMARY KEY (idContrato),
	FOREIGN KEY (idImovel) REFERENCES Imoveis
)

INSERT INTO Imoveis VALUES ('arm�rios embutidos, piscina',4,'casa','alugar',350)
INSERT INTO Imoveis VALUES ('varanda vista para o mar',3,'apto','vender',500000)
INSERT INTO Imoveis VALUES ('quintal amplo e piscina',3,'casa','alugar',420)
INSERT INTO Imoveis VALUES ('sala ampla e decorada',2,'apto','vender',100000)
INSERT INTO Imoveis VALUES ('m�veis para escrit�rio',0,'sala','alugar',120)
INSERT INTO Imoveis VALUES ('ar condicionado central',0,'sala','alugar',340)

INSERT INTO Enderecos VALUES (1,'Av. Nego',523,'Tamba�')
INSERT INTO Enderecos VALUES (2,'Monteiro da Franca',222,'Mana�ra')
INSERT INTO Enderecos VALUES (3,'Olinda',325,'Tamba�')
INSERT INTO Enderecos VALUES (4,'Piau�',41,'Bairro dos Estados')
INSERT INTO Enderecos VALUES (5,'Argemiro Figueiredo',3526,'Bessa')
INSERT INTO Enderecos VALUES (6,'Jo�o Machado',2541,'Centro')

INSERT INTO Contratos VALUES (1,'Maur�cio Rocha Linhares','25-10-2020','� vista')
INSERT INTO Contratos VALUES (2,'Nadir Pereira Brito','02-09-2020','parcelado')
INSERT INTO Contratos VALUES (3,'Robson Gon�alves Fonseca','14-10-2020','financiado')
INSERT INTO Contratos VALUES (4,'Marta Pereira da Silva','25-11-2020','� vista')
INSERT INTO Contratos VALUES (5,'Bianca Reinaldo Sousa','10-05-2020','financiado')

-- Quais as datas dos contratos fechados por clientes com sobrenome Pereira ou Gon�alves?
SELECT data FROM Contratos 
WHERE nome LIKE '%Pereira%' OR nome LIKE '%Gon�alves%'

-- Quais os c�digos dos im�veis com contratos pagos � vista ou parcelados?
SELECT idImovel FROM Contratos
WHERE formaPagamento = '� vista' OR formaPagamento = 'Parcelado'

-- Quais os nomes dos clientes que fecharam contratos em outubro de 2020?
SELECT nome FROM Contratos
WHERE data BETWEEN '01-10-2020' AND '30-10-2020'

-- Qual a forma de pagamento dos contratos fechados por Bianca Reinaldo Sousa?
SELECT formaPagamento FROM Contratos
WHERE nome LIKE '%Bianca Reinaldo Sousa%'

-- Qual a quantidade de casas para alugar?
SELECT COUNT (*) AS 'Casas para alugar' FROM Imoveis
WHERE tipoImovel LIKE '%Casa%' AND tipoNegocio LIKE '%Alugar%'

-- Qual a quantidade de im�veis em Tamba�?

SELECT COUNT (*) AS ' Imoveis em Tamba�' FROM Enderecos
WHERE bairro LIKE '%Tamba�%'

-- Qual a quantidade m�dia de quartos das casas cadastradas na imobili�ria?
SELECT AVG(quantQuartos) AS 'M�dia de quartos' FROM Imoveis

-- Qual a soma dos pre�os das salas para alugar?
SELECT SUM (valor) AS 'Soma valores de salas para alugar' FROM Imoveis
WHERE tipoImovel LIKE '%Sala%' AND tipoNegocio LIKE '%Alugar%'

-- Qual o menor pre�o das casas com piscina?
SELECT MIN (valor) AS 'Casa de menor valor c Piscina' FROM Imoveis
WHERE descricao LIKE '%Piscina%' AND tipoImovel LIKE '%Casa%'

-- Qual o pre�o m�dio dos apartamentos para vender?
SELECT AVG(valor) AS 'Valor m�dio de apartamentos para venda'  FROM Imoveis
WHERE tipoImovel LIKE '%Apto%' AND tipoNegocio LIKE '%Vender%'

-- Quantos bairros t�m im�veis cadastrados?
SELECT COUNT (*) AS 'Quant bairros com imov�is' FROM Enderecos
WHERE idImovel IN (SELECT idImovel FROM Imoveis)

-- Quais os nomes dos clientes que alugaram casas em Tamba�?
SELECT nome FROM Contratos
WHERE idImovel IN 
	(SELECT idImovel FROM Enderecos WHERE bairro LIKE '%Tamba�%')

-- Qual o pre�o m�dio dos im�veis pagos � vista?
SELECT AVG(valor) AS 'Valor m�dio de imov�is pagos � vista' FROM Imoveis
WHERE idImovel IN
	(SELECT idImovel FROM Contratos WHERE formaPagamento LIKE '%� vista%')

-- Quais os bairros dos im�veis que t�m 2 ou 3 quartos?
SELECT bairro FROM Enderecos
WHERE idImovel IN 
	(SELECT idImovel FROM Imoveis WHERE quantQuartos = 2 OR  quantQuartos =3)

-- Quais os nomes dos clientes que alugaram im�veis com piscina?
SELECT nome FROM Contratos
WHERE idImovel IN 
	(SELECT idImovel FROM Imoveis WHERE descricao LIKE '%Piscina%' AND tipoNegocio LIKE '%Alugar%')

-- Quantos apartamentos em Mana�ra est�o para vender?
SELECT COUNT (*) AS 'Quant apto para vendrr em Mana�ra' FROM Imoveis
WHERE tipoNegocio LIKE '%Vender%' AND tipoImovel LIKE '%Apto%' AND idImovel IN
	(SELECT idImovel FROM Enderecos WHERE bairro LIKE '%Mana�ra%')

-- Quantas casas tiveram contratos fechados?
SELECT COUNT (*) AS 'Quant Casas com contrato fechado' FROM Contratos
WHERE idImovel IN 
	(SELECT idImovel FROM Imoveis WHERE tipoImovel LIKE '%Casa%')

-- Quantos im�veis de cada tipo existem na imobili�ria?
SELECT COUNT (CASE WHEN tipoImovel = 'Casa' THEN tipoImovel END) AS 'Quant Aasas',
COUNT (CASE WHEN tipoImovel = 'Apto' THEN TipoImovel END) AS 'Quant Apartamentos',
COUNT (CASE WHEN tipoImovel = 'Sala' THEN tipoImovel END) AS 'Quant Salas' FROM Imoveis


