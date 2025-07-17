{{
    config(
        tags = ['silver', 'fact', 'source1']
    )
}}

with currencyexchange_silver as (
	select Date,
		FromCurrency,
		ToCurrency,
		Exchange
	from {{ref("currencyexchange_bronze")}})

select *
from currencyexchange_silver