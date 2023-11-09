CREATE DATABASE IF NOT EXISTS quanlybanhang;
USE quanlybanhang;

CREATE TABLE customers
(
    customerId   VARCHAR(4) PRIMARY KEY NOT NULL,
    customerName VARCHAR(100)           NOT NULL,
    email        VARCHAR(100)           NOT NULL,
    phone        VARCHAR(25)            NOT NULL,
    address      VARCHAR(255)           NOT NULL
);

CREATE TABLE orders
(
    orderId      VARCHAR(4) PRIMARY KEY NOT NULL,
    customerId   VARCHAR(4)             NOT NULL,
    order_date   DATE                   NOT NULL,
    total_amount DOUBLE                 NOT NULL
);

CREATE TABLE products
(
    productId     VARCHAR(4) PRIMARY KEY NOT NULL,
    productName   VARCHAR(255)           NOT NULL,
    price         DOUBLE                 NOT NULL,
    description   TEXT,
    productStatus BIT(1)
);

CREATE TABLE orders_details
(
    orderId   VARCHAR(4) NOT NULL,
    productId VARCHAR(4) NOT NULL,
    quantity  INT(11)    NOT NULL,
    price     DOUBLE     NOT NULL
);


-- THÊM KHÓA CHÍNH VÀ KHÓA NGOẠI CHO BẢNG

ALTER TABLE orders
    ADD CONSTRAINT fk_customer FOREIGN KEY (customerId) REFERENCES customers (customerId);

ALTER TABLE orders_details
    ADD CONSTRAINT pk_order_product PRIMARY KEY (orderId, productId);
ALTER TABLE orders_details
    ADD CONSTRAINT fk_order FOREIGN KEY (orderId) REFERENCES orders (orderId);
ALTER TABLE orders_details
    ADD CONSTRAINT fk_product FOREIGN KEY (productId) REFERENCES products (productId);


-- THÊM DỮ LIỆU VÀO BẢNG CUSTOMER

INSERT INTO customers(customerId, customerName, email, phone, address)
VALUES ('C001', 'Nguyễn Trung Mạnh', 'manhnt@gmail.com', '984756322', 'Cầu Giấy, Hà Nội'),
       ('C002', 'Hồ Hải Nam', 'namhh@gmail.com', '984875926', 'Ba Vì, Hà Nội'),
       ('C003', 'Tô Ngọc Vũ', 'vutn@gmail.com', '904725784', 'Mộc Châu, Sơn La'),
       ('C004', 'Phạm Ngọc Anh', 'anhpn@gmail.com', '984635365', 'Vinh, Nghệ An'),
       ('C005', 'Trương Minh Cường', 'cuongtm@gmail.com', '989735624', 'Hai Bà Trưng, Hà Nội');

-- THÊM DỮ LIỆU VÀO BẢNG PRODUCT
INSERT INTO products(productId, productName, description, price)
VALUES ('P001', 'Iphone 13 ProMax', 'Bản 512 GB, xanh lá', 22999999),
       ('P002', 'Dell Vostro V3510', 'Core id5, RAM 8GB', 14999999),
       ('P003', 'Macbook Pro M2', '8CPU 10GPU 8GB 256GB', 28999999),
       ('P004', 'Apple Watch Ultra', 'Titanium Alpine Loop Small', 18999999),
       ('P005', 'Airpods 2 2022', 'Spatial Audio', 4090000);

-- THÊM DỮ LIỆU VÀO BẢNG ORDER

INSERT INTO orders(orderId, customerId, total_amount, order_date)
VALUES ('H001', 'C001', 52999997, '2023/2/22'),
       ('H002', 'C001', 80999997, '2023/3/11'),
       ('H003', 'C002', 54359998, '2023/1/22'),
       ('H004', 'C003', 102999995, '2023/3/14'),
       ('H005', 'C003', 80999997, '2022/3/12'),
       ('H006', 'C004', 110449994, '2023/2/1'),
       ('H007', 'C004', 79999996, '2023/3/29'),
       ('H008', 'C005', 29999998, '2023/2/14'),
       ('H009', 'C005', 28999999, '2023/1/10'),
       ('H010', 'C005', 149999994, '2023/4/1');

INSERT INTO orders_details(orderId, productId, quantity, price)
VALUES ('H001', 'P002', 1, 14999999),
       ('H001', 'P004', 2, 18999999),
       ('H002', 'P001', 1, 22999999),
       ('H002', 'P003', 2, 28999999),
       ('H003', 'P004', 2, 18999999),
       ('H003', 'P005', 4, 4090000),
       ('H004', 'P002', 3, 14999999),
       ('H004', 'P003', 2, 28999999),
       ('H005', 'P001', 1, 22999999),
       ('H005', 'P003', 2, 28999999),
       ('H006', 'P005', 5, 4090000),
       ('H006', 'P002', 6, 14999999),
       ('H007', 'P004', 3, 18999999),
       ('H007', 'P001', 1, 22999999),
       ('H008', 'P002', 2, 14999999),
       ('H009', 'P003', 1, 28999999),
       ('H010', 'P003', 2, 28999999),
       ('H010', 'P001', 4, 22999999);


/*
 Bài 3: Truy vấn dữ liệu [30 điểm]:
 */
/*
 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .
 */

SELECT c.customerName AS "Tên khách hàng",
       c.email        AS "Email",
       c.phone        AS "Số điện thoại",
       c.address      AS "Địa chỉ"
FROM customers c;

/*
 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện
thoại và địa chỉ khách hàng).
 */

# SELECT c.customerName AS "Tên khách hàng",
#        c.phone AS "Số điện thoại",
#        c.address AS "Địa chỉ"
# FROM customers c
# WHERE c.customerId IN (
#     SELECT DISTINCT o.customerId
#     FROM orders o
#     WHERE o.order_date >= '2023-03-01' AND o.order_date <= '2023-03-31'
# );

SELECT c.customerName AS "Tên khách hàng",
       c.phone AS "Số điện thoại",
       c.address AS "Địa chỉ"
FROM customers c
INNER JOIN orders o ON o.customerId=c.customerId
WHERE o.order_date BETWEEN '2023-03-01' AND '2023-03-31';

/*
 3. Thống kê doanh thu theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm
tháng và tổng doanh thu ).
 */

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS "Tháng",
    SUM(o.total_amount) AS "Tổng doanh thu"
FROM orders o
WHERE o.order_date >= '2023-01-01' AND o.order_date <= '2023-12-31'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY DATE_FORMAT(o.order_date, '%Y-%m');

/*
4. Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách
hàng, địa chỉ , email và số điên thoại).
 */

SELECT c.customerName AS "Tên khách hàng",
       c.address AS "Địa chỉ",
       c.email AS "Email",
       c.phone AS "Số điện thoại"
FROM customers c
WHERE  c.customerId NOT IN (
    SELECT DISTINCT o.customerId
    FROM orders o
    WHERE o.order_date >= '2023-02-01' AND o.order_date <= '2023-02-28'
);



/*
 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã
sản phẩm, tên sản phẩm và số lượng bán ra).
 */
SELECT p.productId AS "Mã sản phẩm",
       p.productName AS "Tên sản phẩm",
       SUM(od.quantity) AS "Số lượng bán ra"
FROM products p
         LEFT JOIN orders_details od ON p.productId = od.productId
         LEFT JOIN orders o ON od.orderId = o.orderId
WHERE o.order_date >= '2023-03-01' AND o.order_date <= '2023-03-31'
GROUP BY p.productId, p.productName
ORDER BY p.productId;

/*
 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi
tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu). [5 điểm]
 */
SELECT c.customerId AS "Mã khách hàng",
       c.customerName AS "Tên khách hàng",
       SUM(o.total_amount) AS "Mức chi tiêu"
FROM customers c
         LEFT JOIN orders o ON c.customerId = o.customerId
WHERE o.order_date >= '2023-01-01' AND o.order_date <= '2023-12-31'
GROUP BY c.customerId, c.customerName
ORDER BY "Mức chi tiêu" DESC;


/*
 7. Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm
tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) . [5 điểm]
 */

SELECT c.customerName AS "Tên khách hàng",
       o.order_date AS "Ngày tạo đơn hàng",
       SUM(od.quantity) AS "Tổng số lượng sản phẩm",
       SUM(o.total_amount) AS "Tổng tiền"
FROM customers c
         JOIN orders o ON c.customerId = o.customerId
         JOIN orders_details od ON o.orderId = od.orderId
GROUP BY c.customerName, o.orderId, o.order_date
HAVING SUM(od.quantity) >= 5
ORDER BY "Tổng số lượng sản phẩm" DESC;

/*
 Bài 4: Tạo View, Procedure [30 điểm]:





7. Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng. [3 điểm]

8. Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng
tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo. [3 điểm]
9. Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng
thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc. [3 điểm]
10. Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự
giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê. [3 điểm]
 */

/*
 1. Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng
tiền và ngày tạo hoá đơn .
 */
CREATE VIEW OderInfo AS
SELECT c.customerName AS "Tên khách hàng",
       c.phone AS "Số điện thoại",
       c.address AS "Địa chỉ",
       o.total_amount AS "Tổng tiền",
       o.order_date AS "Ngày tạo hoá đơn"
FROM customers c
         JOIN orders o ON c.customerId = o.customerId;

/*
 2. Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng
số đơn đã đặt.
 */
CREATE VIEW CustomerInfo AS
SELECT c.customerName AS "Tên khách hàng",
       c.address AS "Địa chỉ",
       c.phone AS "Số điện thoại",
       COUNT(o.orderId) AS "Tổng số đơn đã đặt"
FROM customers c
         LEFT JOIN orders o ON c.customerId = o.customerId
GROUP BY c.customerName, c.address, c.phone;



/*
3. Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã
bán ra của mỗi sản phẩm.[3 điểm]
 */
CREATE VIEW ProductInfo AS
SELECT p.productName AS "Tên sản phẩm",
       p.description AS "Mô tả",
       p.price AS "Giá",
      SUM(od.quantity) AS "Tổng số lượng đã bán ra"
FROM products p
         LEFT JOIN orders_details od ON p.productId = od.productId
GROUP BY p.productId, p.productName, p.description, p.price;


/*
 4. Đánh Index cho trường `phone` và `email` của bảng Customer.
 */
-- Đánh index cho trường phone
CREATE INDEX index_phone ON customers (phone);
-- Đánh index cho trường email
CREATE INDEX index_email ON customers (email);

/*
 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.[3 điểm]
 */
DELIMITER &&
CREATE PROCEDURE GetAllCustomerInfo(IN customer_id VARCHAR(4))
BEGIN
    SELECT *
    FROM customers
    WHERE customerId = customer_id;
END &&
DELIMITER ;
CALL GetAllCustomerInfo('C001');


/*
 6. Tạo PROCEDURE lấy thông tin của tất cả sản phẩm. [3 điểm]
 */

DELIMITER &&
CREATE PROCEDURE GetAllProducts()
BEGIN
    SELECT *
    FROM products;
END &&
DELIMITER ;

CALL GetAllProducts();


/*
 7. Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng.
 */

DELIMITER &&
CREATE PROCEDURE GetInvoicesByCustomer(IN customer_id VARCHAR(4))
BEGIN
    SELECT o.orderId, o.total_amount, o.order_date
    FROM orders o
    WHERE o.customerId = customer_id;
END &&
DELIMITER ;
CALL GetInvoicesByCustomer('C001');
