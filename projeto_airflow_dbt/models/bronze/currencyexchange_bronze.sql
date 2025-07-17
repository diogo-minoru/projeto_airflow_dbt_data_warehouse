{{
    config(
        tags = ['bronze', 'fact', 'source1']
    )
}}

with currencyexchange_bronze as (
	select Date,
		FromCurrency,
		ToCurrency,
		Exchange
	from public.currencyexchange)

select *
from currencyexchange_bronze