WITH

-- 1. Clientes que compraram "ração"
clientes_racao AS (
    SELECT DISTINCT c.id, c.nome
    FROM clientes c
    JOIN vendas v ON c.id = v.cliente_id
    JOIN itens_venda iv ON v.id = iv.venda_id
    JOIN produtos p ON iv.produto_id = p.id
    WHERE p.nome ILIKE '%ração%'
),

-- 2. Média de compra por cliente
media_clientes AS (
    SELECT v.cliente_id, AVG(iv.quantidade * p.preco) AS media
    FROM vendas v
    JOIN itens_venda iv ON v.id = iv.venda_id
    JOIN produtos p ON iv.produto_id = p.id
    GROUP BY v.cliente_id
),

-- 3. Produtos com mais de 2 unidades vendidas
produtos_mais_2 AS (
    SELECT produto_id, SUM(quantidade) AS total_vendido
    FROM itens_venda
    GROUP BY produto_id
    HAVING SUM(quantidade) > 2
),

-- 4. Top 3 clientes com mais compras
top_clientes AS (
    SELECT cliente_id, COUNT(*) AS total
    FROM vendas
    GROUP BY cliente_id
    ORDER BY total DESC
    LIMIT 3
),

-- 5. Total gasto por cliente
total_gasto AS (
    SELECT v.cliente_id, SUM(iv.quantidade * p.preco) AS total
    FROM vendas v
    JOIN itens_venda iv ON v.id = iv.venda_id
    JOIN produtos p ON iv.produto_id = p.id
    GROUP BY v.cliente_id
),

-- Média geral
media_geral AS (
    SELECT AVG(total) AS media FROM total_gasto
),

-- Pets por cliente
pets_por_cliente AS (
    SELECT cliente_id, COUNT(*) AS qtd_pets
    FROM pets
    GROUP BY cliente_id
),

-- 5c. Clientes acima da média e com pets
clientes_filtrados AS (
    SELECT c.nome
    FROM clientes c
    JOIN total_gasto tg ON c.id = tg.cliente_id
    JOIN pets_por_cliente pc ON c.id = pc.cliente_id
    CROSS JOIN media_geral mg
    WHERE tg.total > mg.media
    AND pc.qtd_pets >= 1
)

SELECT '1 - Clientes que compraram ração' AS tipo, nome::text AS resultado
FROM clientes_racao

UNION ALL

SELECT '2 - Média > 200', cliente_id::text
FROM media_clientes
WHERE media > 200

UNION ALL

SELECT '3 - Produtos com mais de 2 vendas', produto_id::text
FROM produtos_mais_2

UNION ALL

SELECT '4 - Top clientes', cliente_id::text
FROM top_clientes

UNION ALL

SELECT '5c - Clientes acima da média com pets', nome::text
FROM clientes_filtrados;
