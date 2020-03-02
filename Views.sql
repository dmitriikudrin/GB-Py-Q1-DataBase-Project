USE inet_shop;

CREATE VIEW view_user AS
    SELECT username,
           firstname,
           lastname,
           phone,
           email,
           country,
           city,
           about_myself,
           avatar
    FROM users
        JOIN profiles
            ON users.id = profiles.id
ORDER BY username, firstname;



SELECT p.name AS 'Product name',
       p.description AS 'Product description',
       cl1.name AS 'Category',
       s.name AS 'Section',
       spec.data AS 'Specification',
       p.created_at AS 'Creating time'
FROM products p
    JOIN category_lvl1 cl1
        ON p.category_lvl1_id = cl1.id
    JOIN section s
        ON cl1.section_id = s.id
    JOIN specifications spec
        ON p.id = spec.id
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


-- Рекомендации по товаром из самой популярной секции
SELECT s.id AS 'Section id'
FROM users u
    JOIN orders o
        ON u.id = o.user_id
    JOIN orders_details od
        ON o.id = od.id
    JOIN products p
        ON od.product_id = p.id
    JOIN category_lvl1
        ON p.category_lvl1_id = category_lvl1.id
    JOIN section s
        ON category_lvl1.section_id = s.id
WHERE u.id = 12
GROUP BY s.id
ORDER BY COUNT(s.id) DESC
LIMIT 1;



SELECT p.name AS 'Product name',
       p.description AS 'Product description',
       cl1.name AS 'Category',
       s.name AS 'Section',
       spec.data AS 'Specification'
FROM products p
    JOIN category_lvl1 cl1
        ON p.category_lvl1_id = cl1.id
    JOIN section s
        ON cl1.section_id = s.id
    JOIN specifications spec
        ON p.id = spec.id
WHERE s.id = 2 /*and p.id <>*/
ORDER BY RAND()
LIMIT 5;



SET @user_id = 13;
SELECT p.name AS 'Product name',
       p.description AS 'Product description',
       cl1.name AS 'Category',
       s.name AS 'Section',
       spec.data AS 'Specification'
FROM products p
    JOIN category_lvl1 cl1
        ON p.category_lvl1_id = cl1.id
    JOIN section s
        ON cl1.section_id = s.id
    JOIN specifications spec
        ON p.id = spec.id
WHERE (s.id = (SELECT s.id AS 'Section id'
                FROM users u
                    JOIN orders o
                        ON u.id = o.user_id
                    JOIN orders_details od
                        ON o.id = od.id
                    JOIN products p
                        ON od.product_id = p.id
                    JOIN category_lvl1
                        ON p.category_lvl1_id = category_lvl1.id
                    JOIN section s
                        ON category_lvl1.section_id = s.id
                    WHERE u.id = @user_id
                    GROUP BY s.id
                    ORDER BY COUNT(s.id) DESC
                    LIMIT 1)
        AND p.id NOT IN (SELECT p.id
                            FROM users u
                                JOIN orders o
                                    ON u.id = o.user_id
                                JOIN orders_details od
                                    ON o.id = od.id
                                JOIN products p
                                    ON od.product_id = p.id
                                WHERE u.id = @user_id))
ORDER BY RAND()
LIMIT 5;