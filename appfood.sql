CREATE DATABASE if not EXISTS bt_sql

use bt_sql

-- Bảng user
CREATE TABLE `user`(
	user_id INT PRIMARY KEY AUTO_INCREMENT,
	full_name VARCHAR(255),
	email VARCHAR(255),
	`password` VARCHAR(255)
)

INSERT INTO `user`(full_name, emaill, `password`)
VALUES ("Nguyễn Văn A", "a@gmail.com", "123"),
("Trần Văn B", "b@gmail.com", "123"),
("Lê Văn C", "c@gmail.com", "123"),
("Nguyễn Văn D", "d@gmail.com", "123"),
("Trần Văn E", "e@gmail.com", "123"),
("Lê Văn F", "f@gmail.com", "123"),
("Nguyễn Văn G", "g@gmail.com", "123")


-- Bảng food_type
CREATE TABLE food_type(
	type_id INT PRIMARY KEY AUTO_INCREMENT,
	type_name VARCHAR(255)
)

INSERT INTO food_type(type_name)
VALUES ("Món mặn"), 
("Món chay"),
("Bánh mỳ"),
("Món cuốn"),
("Ăn vặt"),
("Món súp"),
("Tráng miệng")


-- Bảng food
CREATE TABLE food(
	food_id INT PRIMARY KEY AUTO_INCREMENT,
	food_name VARCHAR(255),
	image VARCHAR(255),
	price FLOAT,
	`desc` VARCHAR(255),
	type_id INT
)

ALTER TABLE food
ADD CONSTRAINT FOREIGN KEY (type_id) REFERENCES food_type(type_id)

INSERT INTO food(food_name, image, price, `desc`, type_id)
VALUES ("Phở bò", "https://tiki.vn/blog/wp-content/uploads/2023/07/thumb-12.jpg", 35000, "Phở bò đặc biệt", 1),
("Hủ tiếu chay", "https://blog.onelife.vn/wp-content/uploads/2021/11/cach-lam-hu-tieu-chay-djon-gian-mon-chay-814460681392.jpg", 40000, "Đồ chay", 2),
("Mì xào", "", 25000, "", 1),
("Súp cua", "", 15000, "", 6),
("Gỏi cuốn", "", 20000, "", 4),
("Bánh mỳ heo quay", "", 20000, "", 3)


-- Bảng order
CREATE TABLE `order`(
	user_id INT,
	food_id INT,
	amount INT,
	code VARCHAR(255),
	arr_sub_id VARCHAR(255)
)

ALTER TABLE `order`
ADD CONSTRAINT FOREIGN KEY (user_id) REFERENCES `user`(user_id)

ALTER TABLE `order`
ADD CONSTRAINT FOREIGN KEY (food_id) REFERENCES food(food_id)

INSERT INTO `order` (user_id, food_id, amount, code, arr_sub_id)
VALUES (1, 2, 2, "123", "123"),
(1, 1, 2, "", ""),
(2, 3, 1, "", ""),
(3, 4, 3, "", ""),
(3, 2, 1, "", "")


-- Bảng restaurant
CREATE TABLE restaurant(
	res_id INT PRIMARY KEY AUTO_INCREMENT,
	res_name VARCHAR(255),
	image VARCHAR(255),
	`desc` VARCHAR(255)
)

INSERT INTO restaurant (res_name, image, `desc`)
VALUES ("KFC", "", ""),
("McDonald", "", ""),
("Phở 91", "", ""),
("Cơm tấm 123", "", "")

-- Bảng rate_res
CREATE TABLE rate_res(
	user_id INT,
	res_id INT,
	amount INT,
	date_res DATETIME 
)

ALTER TABLE rate_res
ADD CONSTRAINT FOREIGN KEY (user_id) REFERENCES `user`(user_id)

ALTER TABLE rate_res
ADD CONSTRAINT FOREIGN KEY (res_id) REFERENCES restaurant(res_id)

INSERT INTO rate_res (user_id, res_id, amount, date_res)
VALUES (1, 2, 3, "1999-01-01 00:00:00"),
(2, 1, 2, "1999-01-01 00:00:00"),
(3, 4, 1, "1999-01-01 00:00:00"),
(1, 3, 1, "1999-01-01 00:00:00"), 
(4, 1, 2, "1999-01-01 00:00:00")


-- Bảng like_res
CREATE TABLE like_res(
	user_id INT,
	res_id INT,
	date_like DATETIME
)

ALTER TABLE like_res
ADD CONSTRAINT FOREIGN KEY (user_id) REFERENCES `user`(user_id)

ALTER TABLE like_res
ADD CONSTRAINT FOREIGN KEY (res_id) REFERENCES restaurant(res_id)

INSERT INTO like_res (user_id, res_id, date_like)
VALUES (1, 1, "1999-01-01 00:00:00"),
(2, 1, "1999-01-01 00:00:00"),
(2, 2, "1999-01-01 00:00:00"),
(1, 3, "1999-01-01 00:00:00"),
(1, 2, "1999-01-01 00:00:00"),
(3, 1, "1999-01-01 00:00:00"),
(4, 1, "1999-01-01 00:00:00"),
(3, 1, "1999-01-01 00:00:00"),
(5, 1, "1999-01-01 00:00:00"),
(4, 2, "1999-01-01 00:00:00"),
(3, 2, "1999-01-01 00:00:00")

-- Bảng sub_food
CREATE TABLE sub_food(
	sub_id INT PRIMARY KEY AUTO_INCREMENT,
	sub_name VARCHAR(255),
	sub_price FLOAT,
	food_id INT
)

ALTER TABLE sub_food
ADD CONSTRAINT FOREIGN KEY (food_id) REFERENCES food(food_id)

INSERT INTO sub_food(sub_name, sub_price, food_id)
VALUES ("Bò viên", 5000, 1),
("Hủ tiếu thêm", 5000, 2),
("Chả lụa", 2000, 6)


--------------------------------------
-- Tìm 5 người đã like nhà hàng nhiều nhất
SELECT `user`.user_id as "ID", `user`.full_name as "Họ Tên", `user`.email as "Email", COUNT(like_res.user_id) as "Số lần like" FROM like_res 
INNER JOIN `user` ON `user`.user_id = like_res.user_id
GROUP BY like_res.user_id
ORDER BY `Số lần like` DESC
LIMIT 5

-- Tìm 2 nhà hàng có lượt like nhiều nhất
SELECT restaurant.res_id as "ID", restaurant.res_name as "Tên nhà hàng", restaurant.`desc` as "Mô tả", COUNT(like_res.res_id) as "Số lượt thích" FROM like_res
INNER JOIN restaurant ON restaurant.res_id = like_res.res_id
GROUP BY like_res.res_id
ORDER BY `Số lượt thích` DESC
LIMIT 2

-- Tìm người đặt hàng nhiều nhất
SELECT `user`.user_id as "ID", `user`.full_name as "Họ Tên", `user`.email as "Email", COUNT(rate_res.user_id) as "Số lần đặt hàng" FROM rate_res
INNER JOIN `user` ON `user`.user_id = rate_res.user_id
GROUP BY rate_res.user_id
ORDER BY `Số lần đặt hàng` DESC
LIMIT 1

-- Tìm người không hoạt động trong hệ thống
SELECT `user`.user_id as "ID", `user`.full_name as "Họ Tên", `user`.email as "Email" FROM `user`
LEFT JOIN `order` ON `user`.user_id = `order`.user_id
LEFT JOIN rate_res ON `user`.user_id = rate_res.user_id
LEFT JOIN like_res ON `user`.user_id = like_res.user_id
WHERE `order`.user_id IS NUll 
AND rate_res.user_id IS NULL
AND like_res.user_id IS NULL








