{{
    config(
        unique_key = 'StoreKey',
        tags = ['bronze', 'dim', 'source1']
    )
}}

with store_bronze as (
	select StoreKey,
		StoreCode,
		CountryName,
		Description,
		State,
		Status
	from public.store)

select *
from store_bronze