-- 1. Which are the top 10 members by spending

SELECT
    membership_id,
    SUM(total_items_price) AS spending
FROM transactions
GROUP BY membership_id
ORDER BY spending DESC
LIMIT 10
