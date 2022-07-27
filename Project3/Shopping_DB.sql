----PRODUCT TABLE----

CREATE TABLE product (
   product_id bigserial PRIMARY KEY NOT NULL,
   description varchar(100) NOT NULL,
   price numeric (20) NOT NULL
);

INSERT INTO product (description, price)
VALUES ('Coke', 10),
       ('Doritos', 10),
       ('BarOne', 10),
       ('Fanta', 10),
       ('Juice', 10);
       
SELECT * FROM product;

----CART TABLE----

CREATE TABLE cart (
   product_id bigint PRIMARY KEY NOT NULL,
   quantity bigint NOT NULL
);

--INNER JOIN

SELECT description, quantity, price, quantity*price AS subtotal FROM cart
INNER JOIN product ON cart.product_id=product.product_id;

--LOADING TEST DATA INTO THE CART

INSERT INTO cart (product_id, quantity)
VALUES (1, 10),
       (2, 20),
       (3, 30),
       (4, 50),
       (5, 15);

SELECT FROM cart;

--ADDING AN ITEM TO THE CART

UPDATE cart SET cart.quantity = cart.quantity + 1 
WHERE EXISTS(SELECT 1
             FROM cart
             WHERE cart.product_id=1)
             AND cart.product_id = 1;
             

UPDATE cart SET cart.quantity = cart.quantity + 1 
WHERE EXISTS(SELECT 1
             FROM cart
             WHERE cart.product_id=2)
             AND cart.product_id = 2;
             
UPDATE cart SET cart.quantity = cart.quantity + 1 
WHERE EXISTS(SELECT 1
             FROM cart
             WHERE cart.product_id=3)
             AND cart.product_id = 3;
             
UPDATE cart SET cart.quantity = cart.quantity + 1 
WHERE EXISTS(SELECT 1
             FROM cart
             WHERE cart.product_id=4)
             AND cart.product_id = 4;
             
UPDATE cart SET cart.quantity = cart.quantity + 1 
WHERE EXISTS(SELECT 1
             FROM cart
             WHERE cart.product_id=5)
             AND cart.product_id = 5; 
             
--IF QUANTITY = 0 ADD PRODUCT TO CART

INSERT INTO cart (quantity)
SELECT 1
WHERE NOT EXISTS (
SELECT * FROM cart WHERE cart.product_id=5 AND cart.product_id = 5);

--SHOW CART AFTER ADDITION

SELECT description, quantity, price, quantity*price AS subtotal FROM cart
INNER JOIN product ON cart.product_id=product.product_id;


--REMOVING AND ITEM FROM THE CART


UPDATE cart SET cart.quantity = cart.quantity - 1 
WHERE EXISTS(SELECT 1
             FROM cart
             WHERE cart.product_id=1)
             AND cart.product_id = 1;
             

UPDATE cart SET cart.quantity = cart.quantity - 1 
WHERE EXISTS(SELECT 1
             FROM cart
             WHERE cart.product_id=2)
             AND cart.product_id = 2;
             
UPDATE cart SET cart.quantity = cart.quantity - 1 
WHERE EXISTS(SELECT 1
             FROM cart
             WHERE cart.product_id=3)
             AND cart.product_id = 3;
             
UPDATE cart SET cart.quantity = cart.quantity - 1 
WHERE EXISTS(SELECT 1
             FROM cart
             WHERE cart.product_id=4)
             AND cart.product_id = 4;
             
UPDATE cart SET cart.quantity = cart.quantity - 1 
WHERE EXISTS(SELECT 1
             FROM cart
             WHERE cart.product_id=5)
             AND cart.product_id = 5; 
             
--SHOW CART AFTER REMOVE

SELECT description, quantity, price, quantity*price AS subtotal FROM cart
INNER JOIN product ON cart.product_id=product.product_id;

--IF QUANTITY = 0 REMOVE PRODUCT TO CART

DELETE FROM cart WHERE cart.quantity = 0;

--CALCULATING THE SUBTOTAL

SELECT description, quantity, price, quantity*price AS subtotal FROM cart
INNER JOIN product ON cart.product_id=product.product_id;

--CALCULATING THE GRAND TOTAL

SELECT description, quantity, price,quantity*price AS subtotal, (cart.quantity*product.price) AS grand_total FROM cart
INNER JOIN product ON cart.product_id=product.product_id; --TEST 1

SELECT description, quantity, price,quantity*price AS subtotal, (90+200+300+500+180) AS grand_total FROM cart
INNER JOIN product ON cart.product_id=product.product_id; --TEST 2

SELECT sum(cart.quantity*product.price) as grandtotal
FROM cart
INNER JOIN product on product.product_id = cart.product_id; --WORKING QUERY

