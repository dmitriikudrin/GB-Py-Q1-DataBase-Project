CREATE DATABASE inet_shop
DEFAULT CHARSET = utf8;

USE inet_shop;

/* Таблица users.
   Содержит информацию об учетных записях пользователей для аутентификации в магазине.
 */
DROP TABLE IF EXISTS users;
CREATE TABLE users(
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE,
    email VARCHAR(100) UNIQUE,
    password_hash VARCHAR(40),
    phone INT(11),
    type ENUM('user', 'admin')
);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_phone ON users(phone);


/* Таблица profiles.
   Содержит инофрмацию личную информацию о пользователе. Привязанна к учетной записи пользователя.
 */
DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles(
    id SERIAL PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    city VARCHAR(30),
    country VARCHAR(50),
    about_myself VARCHAR(300)
);

ALTER TABLE profiles
    ADD FOREIGN KEY (id) REFERENCES users(id);


DROP TABLE IF EXISTS section;
CREATE TABLE section(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    description VARCHAR(150),
    created_at DATETIME DEFAULT NOW(),
    created_user_id BIGINT UNSIGNED NOT NULL,
    updated_at DATETIME DEFAULT NOW(),
    updated_user_id BIGINT UNSIGNED NOT NULL
);
CREATE INDEX idx_section_name ON section(name);

ALTER TABLE section
    ADD FOREIGN KEY (created_user_id) REFERENCES users(id),
    ADD FOREIGN KEY (updated_user_id) REFERENCES users(id);


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
);
CREATE INDEX category_lvl1_name ON category_lvl1(name);

ALTER TABLE category_lvl1
    ADD FOREIGN KEY (section_id) REFERENCES section(id),
    ADD FOREIGN KEY (created_user_id) REFERENCES users(id),
    ADD FOREIGN KEY (updated_user_id) REFERENCES users(id);


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
);
CREATE INDEX idx_products_name ON products(name);

ALTER TABLE products
    ADD FOREIGN KEY (category_lvl1_id) REFERENCES category_lvl1(id),
    ADD FOREIGN KEY (created_user_id) REFERENCES users(id),
    ADD FOREIGN KEY (updated_user_id) REFERENCES users(id);






