-- MARKET WISE FORECAST ACCURACY

-- creating temporary table to calculate forecast accuracy market wise

create temporary table mkt_abs_net_err 
(
	select
		f.fiscal_year,
		c.market,
		sum(f.sold_quantity) as total_sold_qty,
		sum(f.forecast_quantity) as total_forecast_qty,
		abs(sum(f.forecast_quantity - f.sold_quantity)) as abs_net_error,
		round(abs(sum(f.forecast_quantity - f.sold_quantity)*100/sum(forecast_quantity)), 2) as abs_net_error_pct
	from fact_act_est f
	join dim_customer c
		on c.customer_code = f.customer_code
	where f.fiscal_year = 2021
	group by c.market
);

select * from mkt_abs_net_err;

-- creating a temporary table for forecast accuracy

create temporary table mkt_forecast_acc
(
select 
*,
if(100 < abs_net_error_pct, 0, 100 - abs_net_error_pct) as forecast_accuracy
from mkt_abs_net_err
);

select * from mkt_forecast_acc;

-- overall market wise forecast accuracy report

select
row_number() over (order by forecast_accuracy desc) as mkt_rank,
fiscal_year,
market,
total_sold_qty, 
total_forecast_qty,
abs_net_error_pct,
forecast_accuracy
from mkt_forecast_acc
order by forecast_accuracy desc;

--  top 5 markets with highest forecast accuracy in FY2021

select
row_number() over (order by forecast_accuracy desc) as mkt_rank,
fiscal_year,
market,
total_sold_qty, 
total_forecast_qty,
abs_net_error_pct,
forecast_accuracy
from mkt_forecast_acc
order by forecast_accuracy desc
limit 5;

-- bottom 5 markets with lowest forecast accuracy in FY2021

select
row_number() over (order by forecast_accuracy) as mkt_rank,
fiscal_year,
market,
total_sold_qty,
total_forecast_qty,
abs_net_error_pct,
forecast_accuracy
from mkt_forecast_acc
order by forecast_accuracy
limit 5;