-- ======================================
-- LIMPAR (para não dar erro se já existir)
-- ======================================

DROP TABLE IF EXISTS itens_venda;
DROP TABLE IF EXISTS vendas;
DROP TABLE IF EXISTS pets;
DROP TABLE IF EXISTS produtos;
DROP TABLE IF EXISTS clientes;

-- ======================================
-- CRIAÇÃO DAS TABELAS
-- ======================================

CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    telefone VARCHAR(20)
);

CREATE TABLE pets (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    especie VARCHAR(50),
    raca VARCHAR(50),
    cliente_id INT REFERENCES clientes(id)
);

CREATE TABLE produtos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    preco NUMERIC(10,2)
);

CREATE TABLE vendas (
    id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(id),
    data_venda DATE
);

CREATE TABLE itens_venda (
    id SERIAL PRIMARY KEY,
    venda_id INT REFERENCES vendas(id),
    produto_id INT REFERENCES produtos(id),
    quantidade INT,
    preco_unitario NUMERIC(10,2)
);

-- ======================================
-- INSERTS
-- ======================================

INSERT INTO clientes (nome, telefone) VALUES
('João', '99991111'),
('Maria', '88882222');

INSERT INTO pets (nome, especie, raca, cliente_id) VALUES
('Rex', 'Cachorro', 'Vira-lata', 1),
('Mimi', 'Gato', 'Siamês', 2);

INSERT INTO produtos (nome, preco) VALUES
('Ração', 50),
('Coleira', 30);

INSERT INTO vendas (cliente_id, data_venda) VALUES
(1, CURRENT_DATE),
(2, CURRENT_DATE);

INSERT INTO itens_venda (venda_id, produto_id, quantidade, preco_unitario) VALUES
(1, 1, 2, 50),
(2, 2, 1, 30);

-- ======================================
-- EXERCICIO 1
-- ======================================

SELECT 
    p.nome AS nome_pet,
    p.especie,
    p.raca,
    c.nome AS nome_dono,
    c.telefone
FROM pets p
INNER JOIN clientes c 
    ON p.cliente_id = c.id;

-- ======================================
-- EXERCICIO 2
-- ======================================

SELECT
    c.nome AS cliente,
    v.data_venda,
    pr.nome AS produto,
    iv.quantidade,
    iv.preco_unitario,
    (iv.quantidade * iv.preco_unitario) AS subtotal
FROM vendas v
JOIN clientes c ON v.cliente_id = c.id
JOIN itens_venda iv ON iv.venda_id = v.id
JOIN produtos pr ON iv.produto_id = pr.id
ORDER BY v.data_venda DESC;

-- ======================================
-- EXERCICIO 3
-- ======================================

SELECT
    c.nome,
    COUNT(v.id) AS total_compras
FROM clientes c
LEFT JOIN vendas v 
    ON v.cliente_id = c.id
GROUP BY c.id, c.nome
ORDER BY total_compras DESC;

-- ======================================
-- EXERCICIO 4
-- ======================================

SELECT
    p.nome,
    COALESCE(SUM(iv.quantidade), 0) AS unidades_vendidas
FROM produtos p
LEFT JOIN itens_venda iv 
    ON iv.produto_id = p.id
GROUP BY p.id, p.nome
ORDER BY unidades_vendidas DESC;