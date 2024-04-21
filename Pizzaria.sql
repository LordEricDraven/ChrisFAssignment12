-- Q1-Q2 Create database schema
-- Create the database for the restaurant

create database if not exists `happy_time_pizza`;

-- Create Customer table

create table if not exists `customer`(
	`customer_id` int primary key not null auto_increment,
	`customer_name` varchar(50) not null, 
    `phone_number` varchar(50) not null
);

-- Create Pizza table

create table if not exists `pizza`(
	`pizza_id` int primary key not null auto_increment,
	`pizza_name` varchar(50) not null,
    `pizza_price` decimal(4,2) not null
);

-- Create Order table 

create table if not exists `order`(
	`order_id` int primary key not null auto_increment,
	`customer_id` int not null,
    `order_timestamp` datetime not null,
    foreign key (`customer_id`) references `customer`(`customer_id`)
);

-- Create pizza_order table

create table if not exists `pizza_order`(
	`order_id` int not null,
	`pizza_id` int not null,
    `quantity` int not null,
    foreign key(`order_id`) references `order` (`order_id`),
    foreign key(`pizza_id`) references `pizza` (`pizza_id`)
);

-- Create order_receipt table

create table if not exists `order_receipt`(
	`receipt_id` int primary key not null auto_increment,
    `customer_id` int not null,
    `customer_name` varchar(50) not null,
    `customer_phone` varchar(50) not null,
	`order_id` int not null,
    `order_timestamp` datetime not null,
    `pizza_id` int not null,
    `pizza_name` varchar(50) not null,
    `quantity` int not null,
    `pizza_price` decimal(4,2) not null,
    `total_price` decimal(6,2) not null,
    foreign key(`customer_id`) references `customer`(`customer_id`),
    foreign key(`order_id`) references `order` (`order_id`),
    foreign key(`pizza_id`) references `pizza` (`pizza_id`)
);

-- Q3 Populate the database with pizza details and orders
insert into `pizza`(`pizza_name`, `pizza_price`) values
	('Pepperoni & Cheese', 7.99),
    ('Vegetarian', 9.99),
    ('Meat Lovers', 14.99),
    ('Hawaiian', 12.99);

select * from `pizza`;

insert into `customer`(`customer_name`, `phone_number`) values
	('Trevor Page', '226-555-4982'),
    ('John Doe', '555-555-9498');

select * from `customer`;

insert into `order` (`customer_id`, `order_timestamp`) values
	(1, '2023-09-10 9:47:00'),
    (2, '2023-09-10 13:20:00'), 
    (1, '2023-09-10 9:47:00'), 
    (2, '2023-10-10 10:37:00');
    
select * from `order`;

insert into `pizza_order`(`order_id`, `pizza_id`, `quantity`) values
	(1,1,1), -- order 1 pep
    (1,3,1), -- order 1 meat
    (2,2,1), -- order 2 veg
    (2,3,2), -- order 2 meat
    (3,3,1), -- order 3 meat
    (3,4,1), -- order 3 hawaiian
    (4,2,3), -- order 4 veg
    (4,4,1); -- order 4 hawaiian

select * from `pizza_order`;

insert into `order_receipt` (`customer_id`, `customer_name`, `customer_phone`, `order_id`, `order_timestamp`,
							 `pizza_id`, `pizza_name`, `quantity`, `pizza_price`, `total_price`)
select
	c.`customer_id`,
    c.`customer_name`,
    c.`phone_number` as customer_phone,
    o.`order_id`,
    o.`order_timestamp`,
    po.`pizza_id`,
    pz.`pizza_name`,
    po.`quantity`,
    pz.`pizza_price`,
    po.`quantity` * pz.`pizza_price` as total_price
from
	`order` o
join
	`customer` c on o.`customer_id` = c.`customer_id`
join
	`pizza_order` po on o.`order_id` = po.`order_id`
join
	`pizza` pz on po.`pizza_id` = pz.`pizza_id`;
    
select * from `order_receipt`;



-- Q4 query for customer spendings

select c.`customer_name` as `customer`,
	sum(p.`pizza_price` * po.`quantity`) as `total purchased`
from `customer` c
join `order` o on c.`customer_id` = o.`customer_id`
join `pizza_order` po on po.`order_id` = o.`order_id`
join `pizza` p on p.`pizza_id` = po.`pizza_id`
group by c.`customer_id`;

-- Q5 alter Q4 for query for spendings on which dates

select c.`customer_name` as `customer`,
	date(o.`order_timestamp`) as `date`,
	sum(p.`pizza_price` * po.`quantity`) as `total purchased`
from `customer` c
join `order` o on c.`customer_id` = o.`customer_id`
join `pizza_order` po on po.`order_id` = o.`order_id`
join `pizza` p on p.`pizza_id` = po.`pizza_id`
group by c.`customer_id`, o.`order_timestamp`;
