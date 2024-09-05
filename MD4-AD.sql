create database MD4_AD;
use MD4_AD;
drop database MD4_AD;
CREATE TABLE Category (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    status TINYINT DEFAULT 1 CHECK (status IN (0 , 1))
);

CREATE TABLE Room (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    status TINYINT DEFAULT 1 CHECK (status IN (0, 1)),
    price FLOAT NOT NULL CHECK (price >= 100000),
    salePrice FLOAT DEFAULT 0,
    createdDate DATE DEFAULT(curdate()),
    categoryId INT NOT NULL,
    INDEX idx_name (name),
    INDEX idx_createddate (createdDate),
    INDEX idx_price (price)
);


CREATE TABLE customer (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE CHECK (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Z|a-z]{2,}$'),
    phone VARCHAR(50) NOT NULL UNIQUE,
    address VARCHAR(255),
    createdDate DATE DEFAULT(curdate()) ,
    gender TINYINT NOT NULL CHECK (gender IN (0 , 1, 2)),
    birthday DATE NOT NULL
);

CREATE TABLE booking (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customerId INT NOT NULL,
    status TINYINT DEFAULT 1 CHECK (status IN (0 , 1, 2, 3)),
    bookingdate DATETIME DEFAULT(curdate())
);

CREATE TABLE bookingdetail (
    bookingId INT NOT NULL,
    roomId INT NOT NULL,
    price FLOAT NOT NULL,
    startDate DATETIME NOT NULL,
    endDate DATETIME NOT NULL 
);

alter table room add foreign key (categoryId) references Category(id);
alter table Booking add foreign key (customerId) references customer(id);
alter table bookingdetail add foreign key (bookingId) references booking(id);
alter table bookingdetail add foreign key (roomid) references Room(id);

-- bảng Category
INSERT INTO Category (name, status) VALUES
('Phòng Tiêu Chuẩn', 1),
('Phòng Sang Trọng', 1),
('Phòng Suite', 1),
('Phòng Gia Đình', 1),
('Phòng Executive', 1);

-- bảng Room
INSERT INTO Room (name, status, price, saleprice, CategoryId) VALUES
('Phòng 101', 1, 150000, 120000, 1),
('Phòng 102', 1, 180000, 140000, 1),
('Phòng 201', 1, 250000, 200000, 2),
('Phòng 202', 1, 270000, 220000, 2),
('Phòng 301', 1, 350000, 300000, 3),
('Phòng 302', 1, 370000, 320000, 3),
('Phòng 401', 1, 450000, 400000, 4),
('Phòng 402', 1, 470000, 420000, 4),
('Phòng 501', 1, 550000, 500000, 5),
('Phòng 502', 1, 570000, 520000, 5),
('Phòng 503', 1, 590000, 540000, 5),
('Phòng 504', 1, 610000, 560000, 5),
('Phòng 505', 1, 630000, 580000, 5),
('Phòng 506', 1, 650000, 600000, 5),
('Phòng 507', 1, 670000, 620000, 5);

--  bảng customer
INSERT INTO customer (name, email, phone, address, gender, birthday) VALUES
('Nguyễn Văn A', 'a@example.com', '0123456789', '123 Đường Chính', 1, '1990-01-01'),
('Trần Thị B', 'b@example.com', '0987654321', '456 Đường Phụ', 2, '1985-05-15'),
('Lê Văn C', 'c@example.com', '0234567890', '789 Đường Phụ', 0, '1992-12-25');

--  bảng booking
INSERT INTO booking (customerId, status, bookingdate) VALUES
(1, 0, '2024-09-01 10:00:00'),
(2, 1, '2024-09-02 14:30:00'),
(3, 2, '2024-09-03 09:45:00');

--  bảng bookingdetail
INSERT INTO bookingdetail (bookingId, roomId, price, startDate, endDate) VALUES
(1, 1, 150000, '2024-09-01 10:00:00', '2024-09-03 12:00:00'),
(1, 2, 180000, '2024-09-01 10:00:00', '2024-09-03 12:00:00'),
(2, 3, 250000, '2024-09-02 14:30:00', '2024-09-05 11:00:00'),
(2, 4, 270000, '2024-09-02 14:30:00', '2024-09-05 11:00:00'),
(3, 5, 350000, '2024-09-03 09:45:00', '2024-09-06 10:00:00'),
(3, 6, 370000, '2024-09-03 09:45:00', '2024-09-06 10:00:00');

select * from Category;
select * from customer;
select * from booking;
select * from bookingdetail;

-- yêu cầu 1
-- 1. Lấy ra danh phòng có sắp xếp giảm dần theo Price gồm các cột sau: Id, Name, Price, 
-- SalePrice, Status, CategoryName, CreatedDate;

SELECT 
    r.id Id,
    r.name AS Name,
    r.price Price,
    r.salePrice SalePrice,
    r.status AS Status,
    c.name CategoryName,
    r.createdDate CreatedDate
FROM
    room r
        JOIN
    category c ON r.categoryId = c.id
ORDER BY r.price DESC;

-- 2. Lấy ra danh sách Category gồm: Id, Name, TotalRoom, Status (Trong đó cột Status nếu = 0, 
-- Ẩn, = 1 là Hiển thị ) 

SELECT 
    c.id,
    c.name AS name,
    COUNT(r.id) AS TotalRoom,
    CASE
        WHEN c.status = 1 THEN 'Hien thi'
        ELSE 'An'
    END AS status
FROM
    category c
        LEFT JOIN
    room r ON r.categoryId = c.id
GROUP BY c.id , c.name , c.status;

-- 3. Truy vấn danh sách Customer gồm: Id, Name, Email, Phone, Address, CreatedDate, Gender, 
-- BirthDay, Age (Age là cột suy ra từ BirthDay, Gender nếu = 0 là Nam, 1 là Nữ,2 là khác )


SELECT 
    c.id,
    c.name,
    c.email,
    c.phone,
    c.address,
    c.createdDate,
    CASE
        WHEN c.gender = 0 THEN 'Nam'
        WHEN c.gender = 1 THEN 'Nu'
        ELSE 'khac'
    END AS gender,
    (YEAR(CURDATE()) - YEAR(c.birthday)) as age
FROM
    customer c;
    
-- 4. Truy vấn danh sách Customer gồm: Id, Name, Email, Phone, Address, CreatedDate, Gender, 
-- BirthDay, Age (Age là cột suy ra từ BirthDay, Gender nếu = 0 là Nam, 1 là Nữ,2 là khác )


SELECT 
    c.id,
    c.name,
    c.email,
    c.phone,
    c.address,
    c.createdDate,
    CASE
        WHEN c.gender = 0 THEN 'Nam'
        WHEN c.gender = 1 THEN 'Nu'
        ELSE 'khac'
    END AS gender,
    (YEAR(CURDATE()) - YEAR(c.birthday)) as age
FROM
    customer c;

-- yêu cầu 2
-- 1.View v_getRoomInfo Lấy ra danh sách của 10 phòng có giá cao nhất

CREATE VIEW v_getRoomInfo AS
    SELECT 
        r.id, r.name, r.status, r.price, r.createddate
    FROM
        room r
    ORDER BY price DESC
    LIMIT 10;
    
    -- xem 10 phòng có giá cao nhất.
     SELECT 
        r.id, r.name, r.status, r.price, r.createddate
    FROM
        room r
    ORDER BY price DESC
    LIMIT 10;
    
    -- 2. View v_getBookingList hiển thị danh sách phiếu đặt hàng gồm: Id, BookingDate, Status, 
-- CusName,Email, Phone,TotalAmount ( Trong đó cột Status nếu = 0 Chưa duyệt, = 1 Đã duyệt, 
-- = 2 Đã thanh toán, = 3 Đã hủy 

CREATE VIEW v_getBookingList AS
SELECT 
    b.id   BookingId,
    b.bookingdate   BookingDate,
    CASE 
        WHEN b.status = 0 THEN 'Chưa duyệt'
        WHEN b.status = 1 THEN 'Đã duyệt'
        WHEN b.status = 2 THEN 'Đã thanh toán'
        WHEN b.status = 3 THEN 'Đã hủy'
        ELSE 'Không xác định'
    END AS Status,
    c.name  Customer_Name,
    c.email  Email,
    c.phone  Phone,
    SUM(d.price)  TotalAmount
FROM 
    booking b
JOIN 
    customer c ON b.customerId = c.id
JOIN 
    bookingdetail d ON b.id = d.bookingId
GROUP BY 
    b.id, b.bookingdate, b.status, c.name, c.email, c.phone;

-- xem danh sach
SELECT 
    b.id  BookingId,
    b.bookingdate  BookingDate,
    CASE 
        WHEN b.status = 0 THEN 'Chưa duyệt'
        WHEN b.status = 1 THEN 'Đã duyệt'
        WHEN b.status = 2 THEN 'Đã thanh toán'
        WHEN b.status = 3 THEN 'Đã hủy'
        ELSE 'Không xác định'
    END AS Status,
    c.name  Customer_Name,
    c.email  Email,
    c.phone  Phone,
    SUM(d.price)  TotalAmount
FROM 
    booking b
JOIN 
    customer c ON b.customerId = c.id
JOIN 
    bookingdetail d ON b.id = d.bookingId
GROUP BY 
    b.id, b.bookingdate, b.status, c.name, c.email, c.phone;
    
    
-- yêu cầu 3.
-- Thủ tục addRoomInfo thực hiện thêm mới Room, khi gọi thủ tục truyền đầy đủ các giá trị 
-- của bảng Room ( Trừ cột tự động tăng )

DELIMITER $$
CREATE PROCEDURE addRoomInfo(
  IN p_name VARCHAR(150),
     p_status TINYINT,
     p_price FLOAT,
     p_salePrice FLOAT,
     p_categoryId INT
)
BEGIN
   INSERT INTO Room (name, status, price, salePrice, createdDate, categoryId)
    VALUES (p_name, p_status, p_price, p_salePrice, CURDATE(), p_categoryId);
   END$$
DELIMITER ;

-- 2. Thủ tục getBookingByCustomerId hiển thị danh sách phieus đặt phòng của khách hàng 
-- theo Id khách hàng gồm: Id, BookingDate, Status, TotalAmount (Trong đó cột Status nếu = 0 
-- Chưa duyệt, = 1 Đã duyệt,, = 2 Đã thanh toán, = 3 Đã hủy), Khi gọi thủ tục truyền vào id cảu 
-- khách hàng
DELIMITER $$

CREATE PROCEDURE getBookingByCustomerId(
    IN p_customer_Id INT
)
BEGIN
    SELECT 
        b.id AS BookingId,
        b.bookingdate AS BookingDate,
        CASE
            WHEN b.status = 0 THEN 'Chưa duyệt'
            WHEN b.status = 1 THEN 'Đã duyệt'
            WHEN b.status = 2 THEN 'Đã thanh toán'
            WHEN b.status = 3 THEN 'Đã hủy'
        END AS Status,
        SUM(bd.price) AS TotalAmount
    FROM
        booking b
        JOIN bookingdetail bk ON b.id = bk.bookingId
    WHERE
        b.customerId = p_customer_Id
    GROUP BY b.id, b.bookingdate, b.status;
END $$

DELIMITER ;

-- 3.Thủ tục getRoomPaginate lấy ra danh sách phòng có phân trang gồm: Id, Name, Price, 
-- SalePrice, Khi gọi thủ tuc truyền vào limit và page 
DELIMITER $$
create procedure getRoomPaginate (
p_limit int, p_page int
)
BEGIN
    declare set_page int;
    set set_page = (p_page - 1) * p_limit;
SELECT 
    r.id AS Id,
    r.name AS Name,
    r.price AS Price,
    r.salePrice AS SalePrice
FROM
    room r
LIMIT SET_PAGE , P_LIMIT;
    
END $$

DELIMITER ;
 call getRoomPaginate(3,2);

-- yêu cầu 4
-- Tạo trigger tr_Check_Price_Value sao cho khi thêm hoặc sửa phòng Room nếu nếu giá trị 
-- của cột Price > 5000000 thì tự động chuyển về 5000000 và in ra thông báo ‘Giá phòng lớn 
-- nhất 5 triệu’


-- cho update.
DELIMITER $$
create trigger tr_Check_Update_Price_Value 
before update on room 
for each row 
BEGIN
 if new.price >5000000 then set new.price = 5000000;
 signal sqlstate '45000' set message_text = 'Giá phòng lớn nhất 5 triệu';
 end if;
   END$$
DELIMITER ;

drop trigger tr_Check_Price_Value;
-- cho insert.
DELIMITER $$
create trigger tr_Check_insert_Price_Value 
before insert on room 
for each row 
BEGIN
 if new.price >5000000 then set new.price = 5000000;
 signal sqlstate '45000' set message_text = 'Giá phòng lớn nhất 5 triệu';
 end if;
   END$$
DELIMITER ;

-- 2. Tạo trigger tr_check_Room_NotAllow khi thực hiện đặt pòng, nếu ngày đến (StartDate) 
-- và ngày đi (EndDate) của đơn hiện tại mà phòng đã có người đặt rồi thì hien thi thong bao

DELIMITER $$
create trigger tr_check_Room_NotAllow 
before insert on room 
for each row 
BEGIN
 
 
END$$
DELIMITER ;
