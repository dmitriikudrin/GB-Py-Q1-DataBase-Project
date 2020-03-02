USE inet_shop;

/* Процедура, которая находит самую покупаемую пользователем категорию товаров
   и рекомендует 5 случайных товаров из этой категории, кроме тех, что пользователь уже купил
 */

DELIMITER //
CREATE PROCEDURE recommended_products(IN user_id BIGINT)
BEGIN
    DECLARE user_id BIGINT;
    SET user_id = user_id;
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
    -- Находим самую популярную категорию
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
            -- Убираем товары, которые пользователь уже купил
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
END //
DELIMITER ;

CALL recommended_products(13);
