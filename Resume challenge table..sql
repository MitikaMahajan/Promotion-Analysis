use Resumechallenge9;
-- Add & Calculate promo_price
alter table fact_events
add promo_price decimal(10,2);
update dbo.fact_events
set promo_price=
CASE when promo_type = '25% OFF' then base_price*(1-0.25)
     when promo_type = '33% OFF' then base_price*(1-0.33)
	 when promo_type = '50% OFF' then base_price*(1-0.50)
     when promo_type = '500 Cashback' then base_price-500
	 when promo_type = 'BOGOF' then base_price/2
	 END;

-- Add & Calculate promo_units
alter table fact_events
add promo_units decimal(10,2);

update dbo.fact_events
set promo_units=
case when promo_type = 'BOGOF' then quantity_sold_after_promo*2
     Else quantity_sold_after_promo
END;

-- Add & Calculate Revenue_before_promotion
alter table fact_events
add revenue_BP bigint;

update dbo.fact_events
SET revenue_BP= CAST(base_price as bigint) * CAST(quantity_sold_before_promo as bigint);

-- Add & Calculate revenue_after_promotion
alter table fact_events
add revenue_AP bigint;

update dbo.fact_events
SET revenue_AP= CAST(promo_price as bigint) * CAST(promo_units as bigint);

-- check the newly added columns
select promo_price, promo_units, revenue_AP, revenue_BP
from dbo.fact_events;

-- Add & calculate incremental revenue
alter table fact_events
add IR bigint;

update dbo.fact_events
SET IR= revenue_AP-revenue_BP;

-- Add & calculate ISU
alter table fact_events
add ISU bigint;

update dbo.fact_events
SET ISU= promo_units-quantity_sold_before_promo;


-- check the newly added columns
select promo_price, promo_units, revenue_AP, revenue_BP, IR, ISU
from dbo.fact_events;

-- Add all columns in the view
select*from dbo.fact_events;