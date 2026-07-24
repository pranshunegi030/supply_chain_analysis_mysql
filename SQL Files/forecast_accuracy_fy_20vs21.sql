-- customers whose forecast accuracy has dropped from 2020 to 2021

-- the report has columns
-- customer code
-- customer name
-- market
-- forecast_accuracy_2020
-- forecast_accuracy_2021

select * from fact_act_est;
select * from dim_customer;

with
forecast_2020 as
(
select 
customer_code,
sum(sold_quantity) as total_sold_quantity,
sum(forecast_quantity) as total_forecast_quantity,
abs(sum(forecast_quantity - sold_quantity)) as abs_net_error,
abs(sum(forecast_quantity - sold_quantity)*100/sum(forecast_quantity)) as abs_net_error_pct
from fact_act_est
where fiscal_year = 2020
group by customer_code
),

forecast_2021 as
(
select 
customer_code,
sum(sold_quantity) as total_sold_quantity,
sum(forecast_quantity) as total_forecast_quantity,
abs(sum(forecast_quantity - sold_quantity)) as abs_net_error,
abs(sum(forecast_quantity - sold_quantity)*100/sum(forecast_quantity)) as abs_net_error_pct
from fact_act_est
where fiscal_year = 2021
group by customer_code
),

forecast_20_21 as
(
select 
fy20.customer_code,
c.customer,
c.market,
if(fy20.abs_net_error_pct > 100, 0, 100 -  fy20.abs_net_error_pct) as forecast_accuracy_2020,
if(fy21.abs_net_error_pct > 100, 0, 100 -  fy21.abs_net_error_pct) as forecast_accuracy_2021
from forecast_2020 fy20
join forecast_2021 fy21
using (customer_code)
join dim_customer c
on c.customer_code = fy20.customer_code
)

select *
from forecast_20_21
where forecast_accuracy_2021 < forecast_accuracy_2020
order by forecast_accuracy_2020 desc;