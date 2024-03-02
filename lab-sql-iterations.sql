-- query to find the total business done by each store

select s.store_id, sum(p.amount) as total_business
from sakila.payment p
join sakila.staff st on st.staff_id = p.staff_id
join sakila.store s on s.store_id = st.store_id
group by s.store_id;


-- convert to store procedure

DELIMITER //
create procedure tot_business(in x int)
begin
    select s.store_id, sum(p.amount) as total_business
from sakila.payment p
join sakila.staff st on st.staff_id = p.staff_id
join sakila.store s on s.store_id = st.store_id
group by s.store_id;

end //

DELIMITER ;

CALL tot_business(50);

-- Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

DELIMITER //

create procedure Total_Sales(in store_id int)
begin
    select s.store_id, sum(p.amount) as total_business
    from sakila.payment p
    join sakila.staff st on st.staff_id = p.staff_id
    join sakila.store s on s.store_id = st.store_id
    where s.store_id = store_id
    group by s.store_id;
end //

DELIMITER ;
call Total_Sales(2); 

-- Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). Call the stored procedure and print the results.

DELIMITER //

create procedure tot_business(in input_store_id int)
begin
    declare total_sales_value float;

    select sum(p.amount) into total_sales_value
    from sakila.payment p
    join sakila.staff st on st.staff_id = p.staff_id
    join sakila.store s on s.store_id = st.store_id
    where s.store_id = input_store_id
    group by s.store_id;

    select input_store_id as store_id, total_sales_value as total_sales; 
end //

DELIMITER ;

call tot_business(1); 

-- In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
-- Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.

DELIMITER //

create procedure total_business(in input_store_id int)
begin
    declare total_sales_value float;
    declare flag varchar(20); -- Ajusta el tipo de datos según tus necesidades

    select sum(p.amount) into total_sales_value
    from sakila.payment p
    join sakila.staff st on st.staff_id = p.staff_id
    join sakila.store s on s.store_id = st.store_id
    where s.store_id = input_store_id
    group by s.store_id;

    case
        when total_sales_value > 30000 then
            set flag = 'green_flag';
        else
            set flag = 'red_flag';
    end case; 
    
    select input_store_id as store_id, total_sales_value as total_sales, flag as flag_value;
end //

DELIMITER ;

call total_business(1);






