-- Criação da tabela Cliente
CREATE TABLE Cliente (
    ID_cliente INT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    CPF_CNPJ VARCHAR(20) NOT NULL,
    Tipo_cliente VARCHAR(2) NOT NULL -- PF ou PJ
);

-- Criação da tabela Pedido
CREATE TABLE Pedido (
    ID_pedido INT PRIMARY KEY,
    Data DATE NOT NULL,
    ID_cliente INT NOT NULL,
    Total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (ID_cliente) REFERENCES Cliente(ID_cliente)
);

-- Criação da tabela Produto
CREATE TABLE Produto (
    ID_produto INT PRIMARY KEY,
    Nome_produto VARCHAR(100) NOT NULL,
    Preco DECIMAL(10, 2) NOT NULL
);

-- Criação da tabela Fornecedor
CREATE TABLE Fornecedor (
    ID_fornecedor INT PRIMARY KEY,
    Nome_fornecedor VARCHAR(100) NOT NULL
);

-- Criação da tabela Estoque
CREATE TABLE Estoque (
    ID_estoque INT PRIMARY KEY,
    ID_produto INT NOT NULL,
    Quantidade INT NOT NULL,
    FOREIGN KEY (ID_produto) REFERENCES Produto(ID_produto)
);

-- Criação da tabela FormaPagamento
CREATE TABLE FormaPagamento (
    ID_forma_pagamento INT PRIMARY KEY,
    Descricao VARCHAR(100) NOT NULL
);

-- Criação da tabela Pagamento
CREATE TABLE Pagamento (
    ID_pagamento INT PRIMARY KEY,
    ID_pedido INT NOT NULL,
    ID_forma_pagamento INT NOT NULL,
    Valor DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (ID_pedido) REFERENCES Pedido(ID_pedido),
    FOREIGN KEY (ID_forma_pagamento) REFERENCES FormaPagamento(ID_forma_pagamento)
);

-- Criação da tabela Entrega
CREATE TABLE Entrega (
    ID_entrega INT PRIMARY KEY,
    ID_pedido INT NOT NULL,
    Status VARCHAR(50) NOT NULL,
    Codigo_rastreio VARCHAR(20) NOT NULL,
    FOREIGN KEY (ID_pedido) REFERENCES Pedido(ID_pedido)
);

-- Inserção de dados na tabela Cliente
INSERT INTO Cliente (ID_cliente, Nome, Email, CPF_CNPJ, Tipo_cliente)
VALUES
    (1, 'João da Silva', 'joao@email.com', '123.456.789-00', 'PF'),
    (2, 'Empresa XYZ', 'contato@empresa.com', '12.345.678/0001-00', 'PJ');

-- Inserção de dados na tabela Pedido
INSERT INTO Pedido (ID_pedido, Data, ID_cliente, Total)
VALUES
    (1001, '2023-07-20', 1, 150.00),
    (1002, '2023-07-21', 2, 500.00),
    (1003, '2023-07-22', 1, 200.00);

-- Inserção de dados na tabela Produto
INSERT INTO Produto (ID_produto, Nome_produto, Preco)
VALUES
    (101, 'Camiseta', 50.00),
    (102, 'Calça', 80.00),
    (103, 'Tênis', 120.00);

-- Inserção de dados na tabela Fornecedor
INSERT INTO Fornecedor (ID_fornecedor, Nome_fornecedor)
VALUES
    (201, 'Fornecedor A'),
    (202, 'Fornecedor B');

-- Inserção de dados na tabela Estoque
INSERT INTO Estoque (ID_estoque, ID_produto, Quantidade)
VALUES
    (301, 101, 50),
    (302, 102, 30),
    (303, 103, 100);

-- Inserção de dados na tabela FormaPagamento
INSERT INTO FormaPagamento (ID_forma_pagamento, Descricao)
VALUES
    (401, 'Cartão de Crédito'),
    (402, 'Boleto Bancário');

-- Inserção de dados na tabela Pagamento
INSERT INTO Pagamento (ID_pagamento, ID_pedido, ID_forma_pagamento, Valor)
VALUES
    (501, 1001, 401, 150.00),
    (502, 1002, 402, 500.00),
    (503, 1003, 401, 200.00);

-- Inserção de dados na tabela Entrega
INSERT INTO Entrega (ID_entrega, ID_pedido, Status, Codigo_rastreio)
VALUES
    (601, 1001, 'Em trânsito', 'ABC123'),
    (602, 1002, 'Entregue', 'XYZ456'),
    (603, 1003, 'Aguardando retirada', '123XYZ');

-- Quantos pedidos foram feitos por cada cliente?
SELECT c.Nome AS Cliente, COUNT(p.ID_pedido) AS Num_Pedidos
FROM Cliente c
LEFT JOIN Pedido p ON c.ID_cliente = p.ID_cliente
GROUP BY c.Nome;

-- Algum vendedor também é fornecedor?
SELECT c.Nome AS Vendedor
FROM Cliente c
WHERE c.Tipo_cliente = 'PJ' AND c.ID_cliente IN (
    SELECT ID_cliente
    FROM Pedido
);

-- Relação de produtos fornecedores e estoques
SELECT p.Nome_produto AS Produto, f.Nome_fornecedor AS Fornecedor, e.Quantidade AS Estoque
FROM Produto p
JOIN Estoque e ON p.ID_produto = e.ID_produto
JOIN Fornecedor f ON p.ID_produto = f.ID_fornecedor;

-- Relação de nomes dos fornecedores e nomes dos produtos
SELECT f.Nome_fornecedor AS Fornecedor, p.Nome_produto AS Produto
FROM Fornecedor f
JOIN Produto p ON f.ID_fornecedor = p.ID_produto;
