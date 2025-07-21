{{
    config(
        unique_key = 'productkey',
        tags = ['bronze', 'dim', 'source1']
    )
}}

with product_bronze as (
	select productkey,
	   productname,
	   manufacturer,
	   brand,
	   color,
	   categoryname
    from public.product)

select *
from product_bronze

