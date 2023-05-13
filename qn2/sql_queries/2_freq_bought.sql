-- 2. Which are the top 3 items that are frequently brought by members

SELECT
    item_id,
    COUNT(item_id) AS num_bought
FROM transaction_items
GROUP BY item_id
ORDER BY num_bought DESC
LIMIT 3
