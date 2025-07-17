{{
    config(
        unique_key = 'OrderKey',
        tags = ['silver', 'fact', 'source1']
    )
}}

with orders_silver as (
	select a.orderkey,
	   a.customerkey,
	   a.orderdate,
	   a.storekey
	from {{ref("orders_bronze")}} a)

select *
from orders_silver