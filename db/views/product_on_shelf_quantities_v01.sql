SELECT i.product_id, COUNT(i.product_id) AS quantity
FROM inventories AS i
WHERE i.status = 'on_shelf'
GROUP BY i.product_id
ORDER BY i.product_id;
