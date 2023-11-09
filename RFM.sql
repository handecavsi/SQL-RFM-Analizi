
--RFM Analizi
select invoice_no from ecommerce where invoice_no not like 'C%' limit 100

--recency
with last_invoicedate as (
Select
	customer_id,
	max(invoice_date)::date as last_invoice_date
from ecommerce
where customer_id is not null and unit_price > 0.0 and quantity > 0 and invoice_no not like 'C%'
group by 1
order by 2 
) select 
	customer_id,
	(select max(invoice_date)::date from ecommerce)::date - last_invoice_date as recency
  from last_invoicedate 
  where (select max(invoice_date)::date from ecommerce)::date - last_invoice_date != 0


--frequency
select 
	customer_id,
	count(distinct(invoice_no)) as invoice_count
from ecommerce
where customer_id is not null and unit_price > 0.0 and quantity > 0 and invoice_no not like 'C%'
group by 1
order by 2 

--monetary
with monetary_values as (
	select 
		customer_id,
		unit_price,
		quantity
	from ecommerce
	where customer_id is not null and unit_price > 0.0 and quantity > 0 and invoice_no not like 'C%'
	order by 2
) select 
	customer_id,
	round(sum(unit_price*quantity)::numeric,2) as total_price
  from monetary_values
  group by 1
  order by 2
	
 
--rfm birleştirilir.
with recency as (
with last_invoicedate as (
Select
	customer_id,
	max(invoice_date)::date as last_invoice_date
from ecommerce
where customer_id is not null and unit_price > 0.0 and quantity > 0 and invoice_no not like 'C%'
group by 1
order by 2 
) select 
	customer_id,
	(select max(invoice_date)::date from ecommerce)::date - last_invoice_date as recency 
  from last_invoicedate
  where (select max(invoice_date)::date from ecommerce)::date - last_invoice_date != 0
), frequency as (
	select 
		customer_id,
		count(distinct(invoice_no)) as frequency
	from ecommerce
	where customer_id is not null and unit_price > 0.0 and quantity > 0 and invoice_no not like 'C%'
	group by 1
	order by 2 
), monetary as (
	with monetary_values as (
		select 
			customer_id,
			unit_price,
			quantity
		from ecommerce
		where customer_id is not null and 
		unit_price > 0.0 and quantity > 0 
		and invoice_no not like 'C%'
		order by 2
) select 
	customer_id,
	round(sum(unit_price*quantity)::numeric,2) as monetary
  from monetary_values
  group by 1
  order by 2
), rfm_with_score as (
	select
		r.customer_id,
		recency,
		case 
			when recency < 30 then 5
			when recency >= 30 and recency < 90 then 4
			when recency >= 90 and recency < 150 then 3
			when recency >= 150 and recency < 200 then 2
			else 1
		END as recency_score,
		frequency,
		case 
			when frequency < 2 then 1
			when frequency >= 2 and frequency < 3 then 2
			when frequency >= 3 and frequency < 4 then 3
			when frequency >= 4 and frequency < 6 then 4
			else 5
		END as frequency_score,
		monetary,
		case 
			when monetary < 300 then 1
			when monetary >= 300 and monetary < 600 then 2
			when monetary >= 600 and monetary < 1200 then 3
			when monetary >= 1200 and monetary < 3000 then 4
			else 5
  	END as monetary_score
  from recency as r
  join frequency as f
  on r.customer_id = f.customer_id
  join monetary as m
  on m.customer_id = f.customer_id
) select 
	customer_id,
	recency,
	recency_score,
	frequency,
	frequency_score,
	monetary,
	monetary_score,
	recency_score || ' ' || frequency_score || ' ' || monetary_score as rfm_score
	from rfm_with_score 