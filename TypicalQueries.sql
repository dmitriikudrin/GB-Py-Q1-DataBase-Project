USE inet_shop;

-- Вывод полной информации о конкретном товаре
SELECT p.name AS 'Product name',
       p.description AS 'Product description',
       cl1.name AS 'Category',
       s.name AS 'Section',
       spec.data AS 'Specification',
       p.created_at AS 'Creating time',
       mp.content AS Photo
FROM products p
    JOIN category_lvl1 cl1
        ON p.category_lvl1_id = cl1.id
    JOIN section s
        ON cl1.section_id = s.id
    JOIN specifications spec
        ON p.id = spec.id
    JOIN media_product mp
        ON p.id = mp.product_id
ORDER BY s.name, cl1.name, p.name;


-- Количество заказов пользователя
SELECT u.username AS Username,
       COUNT(o.user_id) AS 'Count of orders'
FROM users u
    JOIN orders o
        ON u.id = o.user_id
GROUP BY u.username;

-- Все заказы пользователя
SELECT u.username AS Username,
       o.id AS 'Numbers of orders'
FROM users u
    JOIN orders o
        ON u.id = o.user_id
WHERE u.id = 12;


-- Список купленных товаров определенным пользователем
SELECT u.username AS Username,
       p.name AS Product,
       od.quantity AS Quantity
FROM users u
    JOIN orders o
        ON u.id = o.user_id
    JOIN orders_details od
        ON o.id = od.id
    JOIN products p
        ON od.product_id = p.id
WHERE u.id = 12;