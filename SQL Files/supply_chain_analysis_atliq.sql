-- ================================================== Chapter 9 ================================================== 

-- forecast accuracy of all customers for a given fiscal year

-- the report should have following fields

-- Costomer code, name, market
-- Total Sold quantity
-- total forecast quantity
-- Net Error
-- Absolute Error
-- Forecast Accuracy %
-- Fiscal Year (for now 21)

use gdb0041;

select * from fact_forecast_monthly;
select * from fact_sales_monthly;

-- Creating a table "fact_act_est" by combining fact_sales_monthly and fact_forecast_monthly which have column 
-- customer code, name, market 
-- sold quantity
-- forcast quantity 

CREATE TABLE fact_act_est
(
SELECT
    s.date,
    s.fiscal_year,
    s.product_code,
    s.customer_code,
    s.sold_quantity,
    f.forecast_quantity
FROM fact_sales_monthly s
LEFT JOIN fact_forecast_monthly f
USING (date, product_code, customer_code)

UNION 

SELECT
    s.date,
    s.fiscal_year,
    s.product_code,
    s.customer_code,
    s.sold_quantity,
    f.forecast_quantity
FROM fact_sales_monthly s
RIGHT JOIN fact_forecast_monthly f
USING (date, product_code, customer_code)
);

-- removing columns where date is null
SELECT COUNT(*)
FROM fact_act_est
WHERE `date` IS NULL;

SELECT *
FROM fact_act_est
WHERE `date` IS NULL
LIMIT 20;

-- disable safe update
SET SQL_SAFE_UPDATES = 0;

DELETE from fact_act_est
where date is null;

-- TURN ON safe update
SET SQL_SAFE_UPDATES = 1;

select * from fact_act_est;

-- updating Sold Quantity of Actual Sales where Sold Quantity is NULL
update fact_act_est
set sold_quantity = 0
where sold_quantity is null;

-- updating Forecast Quantity of Sales where forecast_quantity is NULL
update fact_act_est
set forecast_quantity = 0
where forecast_quantity is null;

-- created a trigger for fact_sales_monthly incase it a new record is inserted so its data get updated in fact_act_est too
show triggers;

-- created a trigger for fact_forecast_monthly, so that if a new record is inserted in fact_forecast_monthly then it should also get inserted in fact_act_est
show triggers;

-- calculating net error %, abs net error % and forecast accuracy

with
forecast_error as
(
	select
		f.date,
		f.fiscal_year,
		f.customer_code,
		c.customer,
		sum(f.sold_quantity) as total_sold_qty,
		sum(f.forecast_quantity) as total_forecast_qty,
		sum(f.forecast_quantity - f.sold_quantity)as net_error,
		sum(f.forecast_quantity - f.sold_quantity)*100/sum(forecast_quantity) as net_error_pct,
		abs(sum(f.forecast_quantity - f.sold_quantity)) as abs_net_error,
		abs(sum(f.forecast_quantity - f.sold_quantity)*100/sum(forecast_quantity)) as abs_net_error_pct
	from fact_act_est f
	join dim_customer c
		on c.customer_code = f.customer_code
	where f.fiscal_year = 2021
	group by f.customer_code
)

select 
*,
if (abs_net_error_pct > 100, 0, 100 - abs_net_error_pct) as forecast_accuracy
from forecast_error
order by forecast_accuracy desc;