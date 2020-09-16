SELECT p.id AS product_id, COUNT(i.product_id) AS quantity
FROM products AS p
LEFT JOIN inventories i ON p.id = i.product_id AND i.status = 'on_shelf'::inventory_statuses
GROUP BY p.id
ORDER BY p.id;
