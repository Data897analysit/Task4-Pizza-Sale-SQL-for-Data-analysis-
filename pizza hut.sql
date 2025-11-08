CREATE TABLE order_detailS(
order_details_id INT NOT NULL,
order_id INT NOT NULL,
pizza_id TEXT NOT NULL,
quantity INT NOT NULL,
PRIMARY KEY(order_details_id)
);

select*from orders


CREATE TABLE orders(
order_id INT NOT NULL,
date DATE NOT NULL,
time TIME NOT NULL,
PRIMARY KEY(order_id)
);


CREATE TABLE pizza_types(
pizza_type_id text not null,
name text not null,
category text not null,
ingredients text not null,
primary key(pizza_type_id)
);

select*from pizza_types

CREATE TABLE pizzas(
pizza_id text not null,
pizza_type_id text not null,
size text not null,
price numeric(5,2) not null,
primary key(pizza_id)
);

select*from pizzas