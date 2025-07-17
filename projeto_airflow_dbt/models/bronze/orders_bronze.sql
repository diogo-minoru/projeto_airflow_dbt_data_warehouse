{{
    config(
        unique_key = 'OrderKey',
        tags = ['bronze', 'fact', 'source1']
    )
}}

with orders_bronze as (
	select OrderKey,
		CustomerKey,
		OrderDate,
		StoreKey,
		CurrencyCode
	from data.orders)

select *
from orders_bronze