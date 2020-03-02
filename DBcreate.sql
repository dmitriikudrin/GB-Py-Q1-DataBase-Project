CREATE DATABASE IF NOT EXISTS inet_shop
DEFAULT CHARSET = utf8;

USE inet_shop;


-- Таблица users.
DROP TABLE IF EXISTS users;
CREATE TABLE users(
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE,
    email VARCHAR(100) UNIQUE,
    password_hash VARCHAR(40),
    phone VARCHAR(20),
    type ENUM('user', 'admin'),
    is_deleted ENUM('no', 'yes') DEFAULT 'no'
) COMMENT 'Информация об учетных записях пользователей для аутентификации в магазине.';
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_phone ON users(phone);


-- Таблица profiles.
DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles(
    id SERIAL PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    city VARCHAR(30),
    country VARCHAR(50),
    about_myself VARCHAR(300) COMMENT 'Раздел "О себе"',
    avatar LONGBLOB
) COMMENT 'Персональные данные пользователя. Привязанна к учетной записи пользователя.';

ALTER TABLE profiles
    ADD FOREIGN KEY (id) REFERENCES users(id);

-- Таблица section.
DROP TABLE IF EXISTS section;
CREATE TABLE section(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    description VARCHAR(150),
    created_at DATETIME DEFAULT NOW(),
    created_user_id BIGINT UNSIGNED NOT NULL,
    updated_at DATETIME DEFAULT NOW(),
    updated_user_id BIGINT UNSIGNED NOT NULL
) COMMENT 'Содержит товарные группы товаров';
CREATE INDEX idx_section_name ON section(name);

ALTER TABLE section
    ADD FOREIGN KEY (created_user_id) REFERENCES users(id),
    ADD FOREIGN KEY (updated_user_id) REFERENCES users(id);


-- Таблица category_lvl1.
DROP TABLE IF EXISTS category_lvl1;
CREATE TABLE category_lvl1(
    id SERIAL PRIMARY KEY,
    section_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(50),
    description VARCHAR(150),
    created_at DATETIME DEFAULT NOW(),
    created_user_id BIGINT UNSIGNED NOT NULL,
    updated_at DATETIME DEFAULT NOW(),
    updated_user_id BIGINT UNSIGNED NOT NULL
) COMMENT 'Содержит категории 1-ого уровня товаров внутри товарных групп.';
CREATE INDEX category_lvl1_name ON category_lvl1(name);

ALTER TABLE category_lvl1
    ADD FOREIGN KEY (section_id) REFERENCES section(id),
    ADD FOREIGN KEY (created_user_id) REFERENCES users(id),
    ADD FOREIGN KEY (updated_user_id) REFERENCES users(id);


-- Таблица products.
DROP TABLE IF EXISTS products;
CREATE TABLE products(
    id SERIAL PRIMARY KEY,
    category_lvl1_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(50),
    description VARCHAR(500),
    created_at DATETIME DEFAULT NOW(),
    created_user_id BIGINT UNSIGNED NOT NULL,
    updated_at DATETIME DEFAULT NOW(),
    updated_user_id BIGINT UNSIGNED NOT NULL
) COMMENT 'Содержит перечень товаров.';
CREATE INDEX idx_products_name ON products(name);

ALTER TABLE products
    ADD FOREIGN KEY (category_lvl1_id) REFERENCES category_lvl1(id),
    ADD FOREIGN KEY (created_user_id) REFERENCES users(id),
    ADD FOREIGN KEY (updated_user_id) REFERENCES users(id);


-- Таблица specifications
DROP TABLE IF EXISTS specifications;
CREATE TABLE specifications(
    id SERIAL PRIMARY KEY,
    data JSON COMMENT 'Характеристики товаров хранятся в файле JSON.'
) COMMENT 'Содержит характеристики товаров.';

ALTER TABLE specifications
    ADD FOREIGN KEY (id) REFERENCES products(id);


-- Таблица basket
DROP TABLE IF EXISTS basket;
CREATE TABLE basket(
    id SERIAL PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    quantity INT UNSIGNED NOT NULL
) COMMENT 'Содержит информацию о товарах, добавленных в корзину пользователем.';
CREATE INDEX idx_basket_user_id ON basket(user_id);

ALTER TABLE basket
    ADD FOREIGN KEY (user_id) REFERENCES users(id),
    ADD FOREIGN KEY (product_id) REFERENCES products(id);


-- Таблица orders
DROP TABLE IF EXISTS orders;
CREATE TABLE orders(
    id      SERIAL PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW()
) COMMENT 'Содержит список сделанных заказов.';

ALTER TABLE orders
    ADD FOREIGN KEY (user_id) REFERENCES users(id);


-- Таблица orders_details
DROP TABLE IF EXISTS orders_details;
CREATE TABLE orders_details(
    id SERIAL PRIMARY KEY,
    product_id BIGINT UNSIGNED NOT NULL,
    quantity INT UNSIGNED NOT NULL
) COMMENT 'Содержит состав сделанных заказов.';

ALTER TABLE orders_details
    ADD FOREIGN KEY (id) REFERENCES orders(id),
    ADD FOREIGN KEY (product_id) REFERENCES products(id);


-- Таблица review
DROP TABLE IF EXISTS review;
CREATE TABLE review(
    id SERIAL PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    title VARCHAR(150),
    body VARCHAR(500)
) COMMENT 'Содержит обзоры на товары.';

ALTER TABLE review
    ADD FOREIGN KEY (user_id) REFERENCES users(id),
    ADD FOREIGN KEY (product_id) REFERENCES products(id);


-- Таблица media_product
DROP TABLE IF EXISTS media_product;
CREATE TABLE media_product(
    id SERIAL PRIMARY KEY,
    type ENUM('photo', 'video'),
    product_id BIGINT UNSIGNED NOT NULL,
    content LONGBLOB
) COMMENT 'Содержит медиа файлы на товары.';

ALTER TABLE media_product
    ADD FOREIGN KEY (product_id) REFERENCES products(id);


-- Таблица media_review
DROP TABLE IF EXISTS media_review;
CREATE TABLE media_review(
    id SERIAL PRIMARY KEY,
    type ENUM('photo', 'video'),
    review_id BIGINT UNSIGNED NOT NULL,
    content LONGBLOB
) COMMENT 'Содержит медиа файлы на обзоры.';

ALTER TABLE media_review
    ADD FOREIGN KEY (review_id) REFERENCES review(id);
