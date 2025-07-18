{{
    config(
        tags = ['gold', 'source1']
    )
}}

with customer_gold as (
    select a.CustomerKey,
        a.givenname || ' ' || a.surname as customer_name,
        a.City,
        a.StateFull,
        a.CountryFull,
        a.age_group
    from {{ref("customer_silver")}} a
)

select *
from customer_gold