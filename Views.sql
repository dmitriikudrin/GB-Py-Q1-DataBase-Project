USE inet_shop;

-- Вывод полной информации п=о пользователе, включая персональные данные
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


-- Вывод полной информации обо всех товарах
CREATE VIEW view_products AS
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


-- Все обзоры конкретного товара
CREATE VIEW view_reviews AS
    SELECT p.id AS 'Product id',
           p.name AS 'Product name',
           r.title AS 'Review title',
           r.body AS 'Review',
           mr.content AS 'Media'
    FROM review r
        JOIN products p
            ON r.product_id = p.id
        JOIN media_review mr
            ON r.id = mr.review_id;






