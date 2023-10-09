# Creating Schemas :-
drop table if exists Product;
CREATE table Product(Product_id integer, Product_name text, Price integer);
INSERT INTO Product(Product_id, Product_name, Price) VALUES
(1,'Pizza',980),
(2,'Burger',870),
(3,'Cake',330);
SELECT * FROM Product;

drop table if exists Users;
CREATE table Users(Userid integer, User_Name varchar(20), Signup_date date);
INSERT INTO Users(Userid, User_Name, Signup_date) VALUES
(101,'Manisha','2014-09-02'),
(102,'Pardhavi','2015-01-15'),
(103,'Shuja','2014-04-11'),
(104,'Mayank','2014-11-02'),
(105,'Samyukta','2015-02-15'),
(106,'Pallav','2014-06-11'),
(107,'Akhil','2014-07-02'),
(108,'Anupam','2015-08-15'),
(109,'Abhishek','2014-09-11'),
(110,'Aryan','2014-10-02'),
(111,'Surbhi','2015-11-15'),
(112,'Sania','2014-12-11'),
(113,'Utkarsh','2014-01-02'),
(114,'Ujjwal','2015-03-15'),
(115,'Yogesh','2014-05-11'),
(116,'Abhay','2014-06-02'),
(117,'Anish','2015-07-15'),
(118,'Aparna','2014-08-11'),
(119,'Rishabh','2014-10-11'),
(120,'Ananya','2014-01-11');
SELECT * FROM Users;

drop table if exists Sales;
CREATE TABLE Sales(Userid integer,Order_date date,Product_id integer); 
INSERT INTO Sales(Userid,Order_date,Product_id) VALUES 
(101,'2017-04-19',2),(103,'2019-12-18',1),(118,'2020-07-20',3),(101,'2019-10-23',2),(101,'2018-03-19',3),(103,'2016-12-20',2),(101,'2016-11-09',1),(101,'2016-05-20',3),(118,'2017-09-24',1),(101,'2017-03-11',2),(101,'2016-03-11',1),(103,'2016-11-10',1),(103,'2017-12-07',2),(103,'2016-12-15',2),(118,'2017-11-08',2),(102,'2018-09-10',3),
(111,'2017-04-19',2),(105,'2019-12-18',1),(105,'2020-07-20',3),(104,'2019-10-23',2),(105,'2018-03-19',3),(106,'2016-12-20',2),(107,'2016-11-09',1),(108,'2016-05-20',3),(108,'2017-09-24',1),(108,'2017-03-11',2),(108,'2020-03-11',1),(104,'2016-11-10',1),(107,'2017-12-07',2),(106,'2016-12-15',2),(107,'2017-11-08',2),(105,'2018-09-10',3),(109,'2017-04-19',2),(110,'2019-12-18',1),(111,'2020-07-20',3),(112,'2019-10-23',2),(113,'2018-03-19',3),(114,'2016-12-20',2),(115,'2016-11-09',1),(114,'2016-05-20',3),(117,'2017-09-24',1),(118,'2020-03-11',2),(119,'2020-03-11',1),(120,'2016-11-10',1),(120,'2017-12-07',2),(120,'2016-12-15',2),(116,'2020-11-08',2),(116,'2020-09-10',3);
SELECT * FROM Sales;

drop table if exists Goldusers_signup;
CREATE TABLE Goldusers_signup(Userid integer,Gold_signup_date date); 
INSERT INTO Goldusers_signup(Userid,Gold_signup_date) VALUES 
(101,'2017-09-22'),
(103,'2017-04-21'),
(120,'2016-12-06');
SELECT * FROM Goldusers_signup;


# QUERIES :-

# Q1 - What is total amount each customer spent on Swiggy ?
SELECT s.userid, SUM(p.Price) as Total_Amount FROM 
Sales s INNER JOIN Product p
on s.product_id = p.product_id
group by s.userid;


# Q2 - How many days has each customer visited Swiggy ?
SELECT userid, count(distinct Order_date) as Total_days FROM Sales
group by userid;


# Q3 - What was the first product purchased by each customer ?
SELECT * FROM
(SELECT *, rank() over(partition by userid order by Order_date) as rnk FROM Sales) a WHERE rnk=1;


# Q4 - What is the most purchased item on the menu and how many times it has been purchased by all the customers ?
Select userid,product_id, count(product_id) as No_of_times FROM Sales WHERE
product_id = (SELECT product_id FROM Sales group by product_id order by count(product_id) desc limit 1) 
group by userid;

# Q5 - Which item is the most popular(Favourite) of each customer ?
SELECT * FROM 
(SELECT *, rank() over(partition by userid order by cnt desc) rnk FROM
(SELECT userid, product_id, count(product_id) cnt FROM Sales group by product_id,userid)a)b
WHERE rnk = 1;


# Q6 - Which item was purchased by the customer after they became the gold member ?
SELECT userid, product_id, Order_date FROM
(SELECT a.*, rank() over(partition by userid order by Order_date asc) rnk FROM
(Select a.userid,a.Order_date,a.product_id,b.gold_signup_date from Sales a INNER JOIN goldusers_signup b 
on a.userid = b.userid and a.Order_date>=b.Gold_signup_date) a) b
WHERE rnk = 1;


# Q7 - Which item was purchased by the customer just before they became gold member ? 
SELECT userid,product_id,Order_date FROM
(SELECT a.*,rank() over(partition by userid order by Order_date desc) rnk FROM
(SELECT a.userid,a.product_id,a.Order_date,b.gold_signup_date FROM Sales a INNER JOIN goldusers_signup b 
on a.userid = b.userid and Order_date<Gold_signup_date) a) b
WHERE rnk = 1;


# Q8 - Rank all transaction of the customers.
SELECT *,rank() over(partition by userid order by Order_date) rnk from Sales;

