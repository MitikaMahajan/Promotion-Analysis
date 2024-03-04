use Resumechallenge9;
--Adhoc req 1

select distinct
dbo.dim_products.product_name, dbo.fact_events.promo_type, dbo.fact_events.base_price

from dbo.fact_events
join dbo.dim_products on dbo.fact_events.product_code=dbo.dim_products.product_code
where dbo.fact_events.promo_type='BOGOF' and dbo.fact_events.base_price>500;

--Adhoc req 2
select city,
COUNT(*) AS Number_of_Stores
from dbo.dim_stores
group by city 
order by Number_of_Stores desc;

-- Adhoc req 3
select dbo.dim_campaigns.campaign_name,
		format(SUM(dbo.fact_events.revenue_BP)/1000000.0, '0.00') AS Revenue_Before_Promotion_in_million,
		format(SUM(dbo.fact_events.revenue_AP)/1000000.0, '0.00') AS Revenue_After_Promotion_in_million
from dbo.fact_events
join dbo.dim_campaigns on dbo.fact_events.campaign_id=dbo.dim_campaigns.campaign_id
group by campaign_name;

--Adhoc req 4
select dbo.dim_products.category,
   SUM(dbo.fact_events.ISU)*100.0/SUM(dbo.fact_events.quantity_sold_before_promo) AS ISU_Percentage,
   DENSE_RANK() OVER (order by SUM(dbo.fact_events.ISU)*100.0/SUM(dbo.fact_events.quantity_sold_before_promo) Desc) AS Ranking
FROM 
	   dbo.fact_events
join dbo.dim_products on dbo.fact_events.product_code=dbo.dim_products.product_code
JOIN dbo.dim_campaigns ON dbo.fact_events.campaign_id = dbo.dim_campaigns.campaign_id
WHERE dbo.dim_campaigns.campaign_name = 'Diwali'
group by dbo.dim_products.category
order by ranking Asc;

--Adhoc req 5
SELECT  top 5 
    dbo.dim_products.product_name,
    dbo.dim_products.category,
    SUM(dbo.fact_events.IR) * 100.0 / SUM(dbo.fact_events.revenue_BP) AS IR_Percentage
FROM 
    dbo.fact_events
JOIN 
    dbo.dim_products ON dbo.fact_events.product_code = dbo.dim_products.product_code
JOIN 
    dbo.dim_campaigns ON dbo.fact_events.campaign_id = dbo.dim_campaigns.campaign_ID
GROUP BY 
    dbo.dim_products.product_name,
    dbo.dim_products.category
ORDER BY 
    IR_Percentage Desc;
