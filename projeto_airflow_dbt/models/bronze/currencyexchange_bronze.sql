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

sellect *
from currencyexchange_bronze