CREATE TABLE users 
(
	user_id SMALLINT PRIMARY KEY, -- т.к. таблица небольшая то для экономии памяти можно выбрать smallint, как это было в прошлом задании в таблицах users и orders 
	birth_date DATE NOT NULL, -- данный формат наиболее подходящий для даты
    sex VARCHAR NOT NULL,  -- для небольшого количества символов оптимальней использовать varchar
    age SMALLINT NOT NULL -- т.к. значения небольшие smallint подходяящий вариант
);

INSERT INTO users (user_id,birth_date,sex, age) 
SELECT 
generate_series,
now() - (random() * (interval '99 years')),
md5(random()::VARCHAR), --при генерации как в примере unnest(array['f','m']) id дублируется(1,1,2,2 вместо 1,2)
floor(random() * 99)::SMALLINT
FROM generate_series(1, 20);

CREATE TABLE items 
(
	item_id SMALLINT PRIMARY KEY, -- smallint подходит лучше int
	description TEXT NOT NULL, -- для большого текста text оптимальнее varchar
    price REAL NOT NULL, -- т.к. в цене может присутствовать дробная часть используем real а не int
    category VARCHAR NOT NULL -- для небольшого текста varchar подходит лучше всего
);

INSERT INTO  items (item_id,description,price,category) 
SELECT 
generate_series,
md5(random()::text),
(random() * 300)::REAL,
md5(random()::VARCHAR)
FROM generate_series(1, 20);

CREATE TABLE ratings
(
    rating_id SMALLINT PRIMARY KEY, --добавляем столбец, который будет ключом в данной таблице
	item_id SMALLINT REFERENCES items(item_id), --добавляем ссылку, которая свяжет с таблицей items
	user_id SMALLINT REFERENCES users(user_id), --добавляем ссылку, которая свяжет с таблицей users
    review TEXT NOT NULL, -- текст может быть большим выбираем text
    rating REAL NOT NULL -- рейтинг может быть дробным выбираем real
);

INSERT INTO ratings (rating_id,item_id, user_id, review,rating) 
SELECT 
generate_series,
generate_series,
generate_series,
md5(random()::text),
(random() * 10)::REAL
FROM generate_series(1, 20);

--SELECT * FROM ratings, users
--where ratings.user_id= users.user_id

--SELECT * FROM ratings, items
--where ratings.item_id= items.item_id

SELECT * FROM ratings, users, items 
where ratings.user_id= users.user_id AND ratings.item_id= items.item_id
                       