{{
    config(
        tags = ['silver', 'fact', 'source1']
    )
}}

with orderrows_silver as (
	select a.OrderKey,
		a.LineNumber,
		a.ProductKey,
		a.Quantity,
		a.NetPrice,
		a.UnitCost,
		(a.quantity * a.netprice) * c.exchange as total_net_order_usd,
		(a.quantity * a.unitcost) * c.exchange as total_net_cost_usd,
		((a.quantity * a.netprice) - (a.quantity - a.unitcost)) * c.exchange as total_net_profit_usd
	from {{ref("orderrows_bronze")}} a
    join {{ref("orders_bronze")}} b on a.orderkey = b.orderkey
    join {{ref("currencyexchange_bronze")}} c on b.orderdate = c.date and b.currencycode = c.fromcurrency
	where c.tocurrency = 'USD')

select *
from orderrows_silver