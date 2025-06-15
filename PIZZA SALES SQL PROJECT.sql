##Basic
Retrieve the total number of orders placed.
Calculate the total revenue generated from pizza sales.
Identify the highest-priced pizza.
Identify the most common pizza size ordered.
List the top 5 most ordered pizza types along with their quantities.

select*from order_details;
select*from orders;
select*from pizza_types;
select*from pizzas;

#1
select count(order_id) as total_count
from orders;

#2
select
round(sum(order_details.quantity* pizzas.price),2) as revenue
from order_details join pizzas
on pizzas.pizza_id = order_details.pizza_id;

#3
select pizza_types.name, pizzas.price
from pizzas_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1;


#4
select pizzas.size, count(order_details.order_details_id) as order_count
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size
order by order_count;

#5
SELECT pizza_types.name, 
       SUM(order_details.quantity) AS total_quantity
FROM pizza_types 
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY total_quantity DESC
LIMIT 5;

__________________________________________________________________________
Intermediate:
Join the necessary tables to find the total quantity of each pizza category ordered.
Determine the distribution of orders by hour of the day.
Join relevant tables to find the category-wise distribution of pizzas.
Group the orders by date and calculate the average number of pizzas ordered per day.
Determine the top 3 most ordered pizza types based on revenue.

select*from order_details;
select*from orders;
select*from pizza_types;
select*from pizzas;

#1
select sum(order_details.quantity), pizza_types.category, pizza_types.name
from order_details
join pizzas on order_details.pizza_id = pizzas.pizza_id
join pizza_types on pizzas.pizza_type_id=pizza_types.pizza_type_id
group by pizza_types.name, order_details.quantity, pizza_types.category;

#2
select hour(time), count(order_id) from orders
group by hour(time);

#3
select pt.category, count(pt.name) 
from pizza_types pt
join pizzas pi on pt.pizza_type_id = pi.pizza_type_id
group by pt.category;

#4 Group the orders by date and calculate the average number of pizzas ordered per day.
select avg(quantity) from
(select o.date, sum(od.quantity) as quantity
from orders o
join order_details od on o.order_id = od.order_id
group by o.date) as order_quantity;

#5Determine the top 3 most ordered pizza types based on revenue.
select pt.name, sum(od.quantity*pi.price) as revenue_generated
from pizza_types pt
join pizzas pi on pi.pizza_type_id = pt.pizza_type_id
join order_details od on od.pizza_id = pi.pizza_id
group by pt.name
order by revenue_generated
limit 3;

Advanced:
Calculate the percentage contribution of each pizza type to total revenue.
Analyze the cumulative revenue generated over time.
Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select*from order_details;
select*from orders;
select*from pizza_types;
select*from pizzas;


#1Calculate the percentage contribution of each pizza type to total revenue.
select pt.category, 
(sum(od.quantity*pi.price) / (select
round(sum(order_details.quantity* pizzas.price),2) as total_sales
from order_details join pizzas
on pizzas.pizza_id = order_details.pizza_id ))*100 as revenue
from pizza_types pt
join pizzas pi on pt.pizza_type_id = pi.pizza_type_id
join order_details od on pi.pizza_id = od.pizza_id
group by pt.category
order by revenue desc
limit 3;

#2Analyze the cumulative revenue generated over time.
SELECT 
    date,
    SUM(revenue) OVER (ORDER BY date) AS cumulative_revenue
FROM (
    SELECT 
        orders.date, 
        SUM(od.quantity * pi.price) AS revenue
    FROM orders 
    JOIN order_details od ON orders.order_id = od.order_id 
    JOIN pizzas pi ON pi.pizza_id = od.pizza_id 
    GROUP BY orders.date
) AS daily_sales;


#3
select pt.name, sum(od.quantity*pi.price) as revenue
from pizza_types pt
join pizzas pi on pt.pizza_type_id = pi.pizza_type_id
join order_details od on pi.pizza_id = od.pizza_id
group by pt.name
order by revenue
limit 3;




