# supply_chain_analysis_mysql
**Project Overview :**
As AtliQ Hardware expanded its operations across multiple regions and customers, maintaining an accurate demand forecast became increasingly challenging.

Inaccurate forecasts resulted in:
1) Excess inventory carrying costs
2) Stock shortages
3) Reduced customer satisfaction
4) Inefficient production planning

Using SQL, this project analyzes historical sales and forecast data to identify forecasting gaps and provide insights that support better supply chain decisions.

**Problem Statement :**
AtliQ Hardware wants to evaluate the effectiveness of its demand forecasting process.

The objective is to compare forecasted demand with actual sales to identify:

1) Forecast Accuracy
2) Net Error
3) Absolute Error
4) Customer-level forecasting performance
5) Product-level forecasting performance
6) Overall supply chain efficiency

The insights generated from this analysis help business stakeholders improve demand planning, inventory management, and customer service.

**Database Used :**
The project uses supply chain data containing information such as:

1) Customers
2) Products
3) Markets
4) Monthly Sales
5) Monthly Forecasts

The dataset contains **1.4+ million records**, making query optimization and efficient SQL writing an important part of the project.

**Business Metrics Analyzed :**

1) Forecast Accuracy (%)
2) Net Error
3) Absolute Error
4) Forecast vs Actual Sales
5) Customer Performance
6) Product Performance
7) Market-wise Performance
8) Monthly Sales Trends

**SQL Analysis Performed :**

This project consists of multiple SQL scripts that simulate a real-world supply chain analytics workflow for AtliQ Hardware. Each script answers a specific business problem related to demand forecasting and supply chain performance.

**1) Data Preparation & Consolidation :**

i) Combined the **Actual Sales** (fact_sales_monthly) and **Forecast Sales** (fact_forecast_monthly) tables into a unified table named fact_act_est.

ii) Removed inconsistent records with missing dates.

iii) Replaced NULL values in sold and forecast quantities with zero.

iv) Created database triggers to automatically keep the consolidated table updated whenever new sales or forecast records are inserted.

**2) Customer-wise Forecast Accuracy Analysis :**

Calculated the following KPIs for every customer for Fiscal Year 2021:

i) Total Sold Quantity
ii) Total Forecast Quantity
iii) Net Error
iv) Net Error %
v) Absolute Net Error
vi) Absolute Net Error %
vii) Forecast Accuracy %

This analysis helps identify customers whose demand forecasts closely match actual sales.
