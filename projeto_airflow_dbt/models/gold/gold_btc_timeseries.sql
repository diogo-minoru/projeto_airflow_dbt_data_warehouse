SELECT 
    datetime_s as datetime_g,
    open_s as open_g,
    high_s as high_g,
    low_s as low_g,
    close_s as close_g
FROM {{ref("silver_btc_timeseries")}}