{{
    config(
        tags = ['gold', 'source1']
    )
}}

with total_revenue_by_date as (
    select b.orderdate,
           sum(a.total_net_order_usd) as net_order_usd,
           sum(a.total_net_cost_usd) as net_cost_usd,
           sum(a.total_net_profit_usd) as nt_profit_usd
    from {{ref("orderrows_silver")}} a
    join {{ref("orders_silver")}} b on a.orderkey = b.orderkey
    group by b.orderdate
)

select *
from total_revenue_by_date