{{
    config(
        materialized = 'table',
        unique_key = 'datetime_s',
        tags = ['silver', 'fact', 'crm']
    )
}}

SELECT 
    datetime_b as datetime_s,
    open_b as open_s,
    high_b as high_s,
    low_b as low_s,
    close_b as close_s 
FROM {{ref("bronze_btc_timeseries")}}