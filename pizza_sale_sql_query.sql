use practice;

--  Retrieve the total number of orders placed.

select count(order_id) as Number_of_order_placed
from orders;

--  Calculate the total revenue generated from pizza sales

select round(sum(price * quantity),2) as total_revenue
from pizzas 
join order_details 
on pizzas.pizza_id = order_details.pizza_id;


--  Identify the highest-priced pizza

SELECT 
    `name`, price
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
ORDER BY price DESC
LIMIT 1;

--  Identify the most common pizza size ordered

select size , count(order_id) as order_count
from pizzas 
join order_details 
on pizzas.pizza_id = order_details.pizza_id
group by size 
order by order_count desc;


--  List the top 5 most ordered pizza types along with their quantities
select `name`, sum(quantity) as count_of_pizza
from pizza_types
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by `name`
order by count_of_pizza desc limit 5;


--  Determine the distribution of orders by hour of the day

select hour(order_time) as hour_ , count(order_id) as order_count
from orders
group by hour_;

--  Group the orders by date and calculate the average number of pizzas ordered per day
with cte as (
select order_date , sum(order_details.quantity) as order_count
from orders
join order_details
on orders.order_id = order_details.order_id
group by order_date
)
select   round(avg(order_count),0) as avg_order
from cte ;


--  Determine the top 3 most ordered pizza types based on revenue

select pizza_types.`name` as Pizza_Name,sum(pizzas.price * order_details.quantity) as Total_Revenue
from pizzas
join order_details
on pizzas.pizza_id = order_details.pizza_id
join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by Pizza_Name
order by Total_Revenue desc
limit 3;

--  Calculate the percentage contribution of each pizza type to total revenue

select `name` , concat(round(sum(price * quantity)  / (select (sum(price * quantity)) as total_revenue
from pizzas 
join order_details 
on pizzas.pizza_id = order_details.pizza_id) *100,0),'%') as Revenue
from pizza_types
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by `name`
order by Revenue desc;


--  Analyze the cumulative revenue generated over time

with cte as 
(
select order_date , round(sum(quantity * price),2) as Revenue_by_day
from orders
join order_details
on orders.order_id = order_details.order_id
join pizzas 
on order_details.pizza_id = pizzas.pizza_id
group by order_date
)
select order_date,
round(sum(Revenue_by_day)over(order by order_date),2) as cumulative_Revenue
from cte









