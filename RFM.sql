select * from booking limit 100

--Recency hesaplamak için müşterinin en son yaptığı alışveriş tarihi bilgisi gerekir.
--Müşteri bazında max. tarihler çekilir.

with last_bookingdate as (
Select
	contactid,
	max(bookingdate)::date as last_bookingdate
from booking
group by 1
) select 
	contactid,
	current_date - last_bookingdate as recency
  from last_bookingdate
  
select max(bookingdate) --Eski veri setlerinde bugünün tarihi yerine kullanılabilir.


--Frequency için her müşterinin bugüne kadarki başarılı rezervasyon sayısını getirin.

select 
	contactid,
	count(b.id) as success_booking_count
from booking as b
join payment as p
on b.id=p.bookingid
where p.paymentstatus='ÇekimBaşarılı'
group by 1

--Monetary için her müşterinin bugüne kadarki başarılı toplam ödeme tutarını getiriniz.
select 
	contactid,
	sum(p.amount) as success_total_amount
from booking as b
join payment as p
on b.id=p.bookingid
where p.paymentstatus='ÇekimBaşarılı'
group by 1




--En son her bir kavram birleştirilir.

with recency as (
with last_bookingdate as (
Select
	contactid,
	max(bookingdate)::date as last_bookingdate
from booking
group by 1
) select 
	contactid,
	current_date - last_bookingdate as recency
  from last_bookingdate
), frequency as (
select 
	contactid,
	count(b.id) as frequency
from booking as b
join payment as p
on b.id=p.bookingid
where p.paymentstatus='ÇekimBaşarılı'
group by 1
),
monetory as (
select 
	contactid,
	sum(p.amount) as monetory
from booking as b
join payment as p
on b.id=p.bookingid
where p.paymentstatus='ÇekimBaşarılı'
group by 1
)
select 
	r.contactid,
	recency,
	case 
		when recency < 100 then 1
		when recency >= 100 and recency <= 250 then 2
		else 3
	END as recency_score,
	frequency,
	monetory
from recency r
join frequency f
on r.contactid = f.contactid
join monetory m
on f.contactid = m.contactid


