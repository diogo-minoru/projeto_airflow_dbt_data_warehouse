{{
    config(
        unique_key = 'productkey',
        tags = ['silver', 'dim', 'source1']
    )
}}

with product_siver as (
	select productkey,
	   productname,
	   manufacturer,
	   brand,
	   color,
	   categoryname
	from {{ref("product_bronze")}})

select *
from product_siver