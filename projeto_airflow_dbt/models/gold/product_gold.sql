{{
    config(
        tags = ['gold', 'source1']
    )
}}

with product_gold as (
    select a.productkey,
	   a.productname,
	   a.manufacturer,
	   a.brand,
	   a.color,
	   a.categoryname
    from {{ref("product_silver")}} a
)

select *
from product_gold