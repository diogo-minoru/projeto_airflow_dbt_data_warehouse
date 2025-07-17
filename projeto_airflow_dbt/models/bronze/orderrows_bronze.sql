{{
    config(
        tags = ['bronze', 'fact', 'source1']
    )
}}

with orderrows_bronze as (
	select OrderKey,
		LineNumber,
		ProductKey,
		Quantity,
		NetPrice,
		UnitCost
	from public.orderrows)

select *
from orderrows_bronze