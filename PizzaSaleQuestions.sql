-- Retrive the total number of orders placed

select count(order_id) as Total_orders from orders;

-- Calculate the total revenue generated from pizza sales.
select round(sum(order_details.quantity * pizzas.price),2) as Total_Revenue
from order_details join pizzas
on pizzas.pizza_id = order_details.pizza_id


-- Identify the highest-priced pizza.
select pizza_types.name,pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1;

-- Identify the most common pizza size ordered.

select pizzas.size, count(order_details_id) as order_count
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size order by order_count desc limit 1;

-- List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name, sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by quantity desc limit 5;


-- Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category, sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by quantity desc;

-- Determine the distribution of orders by hour of the day

select extract(hour from time) as hour , count(order_id) as order_count 
from orders
group by hour
order by order_count desc;

-- Join relevant tables to find the category-wise 
-- distribution of pizzas.
select category, count(name) from pizza_types
group by category;

-- Group the orders by date and calculate 
-- the average number of pizzas ordered per day.

select round(avg(quantity),0) as Avg_pizzas_ordered_per_day 
from (select orders.date ,
sum(order_details.quantity) as quantity
from orders join order_details
on orders.order_id = order_details.order_id
group by orders.date) as order_quantity; 

-- Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name,
sum(order_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id= pizza_types. pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by revenue desc limit 3;

-- Calculate the percentage contribution of each pizza type to total revenue.

with PizzaRevenue AS (select pizza_types.category,sum(order_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id= pizza_types. pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category),
TotalRevenue as (select sum(revenue) as Total_Revenue
from PizzaRevenue)

select 
p.category,round((p.revenue/t.Total_Revenue)*100,2) as percentage_contribution
from PizzaRevenue p, TotalRevenue t
order by percentage_contribution desc;

-- Analyze the cumulative revenue generated over time.
CREATE VIEW total_revenue_view AS
SELECT 
    pizza_types.category AS pizza_category,
    pizza_types.name AS pizza_type,
    orders.date AS order_date,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM pizza_types
JOIN pizzas
    ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details
    ON order_details.pizza_id = pizzas.pizza_id
JOIN orders
    ON orders.order_id = order_details.order_id
GROUP BY pizza_types.category, pizza_types.name, orders.date;


   SELECT 
    order_date,
    SUM(daily_revenue) OVER (ORDER BY order_date) AS cumulative_revenue
FROM (
    SELECT 
        order_date,
        SUM(revenue) AS daily_revenue
    FROM total_revenue_view
    GROUP BY order_date
) AS daily_totals
ORDER BY order_date;




-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
WITH ranked_pizzas AS (
    SELECT 
        pizza_category,
        pizza_type,
        SUM(revenue) AS total_revenue,
        RANK() OVER (PARTITION BY pizza_category ORDER BY SUM(revenue) DESC) AS rank
    FROM total_revenue_view
    GROUP BY pizza_category ,pizza_type
)
SELECT *
FROM ranked_pizzas
WHERE rank <= 3;



