{{
    config(
        tags = ['gold', 'source1']
    )
}}

with orderrows_gold as (
    select a.OrderKey,
		a.LineNumber,
		a.ProductKey,
		a.Quantity,
		a.NetPrice,
		a.UnitCost,
		a.total_net_order_usd,
		a.total_net_cost_usd,
		a.total_net_profit_usd
    from {{ref("orderrows_silver")}} a
)

select *
from orderrows_gold