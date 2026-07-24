-- top 10 and bottom 10 customers with highest forecast accuracy in fiscal year 2021

-- creating temporary table to get forecast accuracy

create temporary table absolute_err 
(
	select
		f.fiscal_year,
		f.customer_code,
		c.customer,
		sum(f.sold_quantity) as total_sold_qty,
		sum(f.forecast_quantity) as total_forecast_qty,
		abs(sum(f.forecast_quantity - f.sold_quantity)) as abs_net_error,
		round(abs(sum(f.forecast_quantity - f.sold_quantity)*100/sum(forecast_quantity)), 3) as abs_net_error_pct
	from fact_act_est f
	join dim_customer c
		on c.customer_code = f.customer_code
	where f.fiscal_year = 2021
	group by f.customer_code
);

select * from absolute_err;

-- creating temporary table for forecast accuracy

create temporary table forecast_acc
(
select 
*,
if(100 < abs_net_error_pct, 0, 100 - abs_net_error_pct) as forecast_accuracy
from absolute_err
);

select * from forecast_acc;

-- top 10 customers

select 
row_number() over (order by forecast_accuracy desc) as cust_rnk,
fiscal_year,
customer_code,
customer,
total_sold_qty,
total_forecast_qty,
abs_net_error_pct,
forecast_accuracy
from forecast_acc
order by forecast_accuracy desc
limit 10;

-- bottom 10 customers

select
row_number() over (order by forecast_accuracy) as cust_rnk,
fiscal_year, 
customer_code,
customer,
total_sold_qty,
total_forecast_qty,
abs_net_error_pct,
forecast_accuracy
from forecast_acc
order by forecast_accuracy
limit 10;