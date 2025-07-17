{{
    config(
        tags = ['gold', 'source1']
    )
}}

with orders_gold as (
    select a.orderkey,
	   a.customerkey,
	   a.orderdate,
	   a.storekey
    from {{ref("orders_silver")}} a
)

select *
from orders_gold