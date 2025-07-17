{{
    config(
        tags = ['gold', 'source1']
    )
}}

with store_gold as (
    select a.StoreKey,
		a.CountryName,
		a.Description,
		a.State		
    from {{ref("store_silver")}}
)

select *
from store_gold