{{
    config(
        unique_key = 'CustomerKey',
        tags = ['silver', 'dim', 'source1']
    )
}}

with customer_silver as (
    select CustomerKey,
        GivenName,
        Surname,
        givenname || ' ' || surname as customer_name,
        City,
        StateFull,
        CountryFull,
        Age,
        case when age < 18 then 'Menor que 18 anos'
             when age < 25 then 'Entre 18 e 24'
             when age < 35 then 'Entre 25 e 34'
             when age < 50 then 'Entre 35 e 49'
             when age < 60 then 'Entre 50 e 59'
             else 'Maior que 60' end as age_group
    from {{ref("customer_bronze")}})

select *
from customer_silver