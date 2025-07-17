{{
    config(
        unique_key = 'StoreKey',
        tags = ['silver', 'dim', 'source1']
    )
}}

with store_silver as (
	select StoreKey,
		CountryName,
		Description,
		State,
		Status
	from {{ref("store_bronze")}})

select *
from store_silver