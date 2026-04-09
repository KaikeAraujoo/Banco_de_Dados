SELECT
    p.nome,
    COALESCE(SUM(iv.quantidade), 0) AS unidades_vendidas
FROM produtos p
LEFT JOIN itens_venda iv 
    ON iv.produto_id = p.id
GROUP BY p.id, p.nome
ORDER BY unidades_vendidas DESC;