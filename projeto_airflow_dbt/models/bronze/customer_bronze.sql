{{
    config(
        unique_key = 'CustomerKey',
        tags = ['bronze', 'dim', 'source1']
    )
}}

with customer_bronze as (
    select CustomerKey,
        GivenName,
        Surname,
        City,
        StateFull,
        CountryFull,
        Age
    from public.customer)

select *
from customer_bronze