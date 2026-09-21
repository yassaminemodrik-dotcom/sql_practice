--compare different sources of trafic
WITH source_funnel AS (
  SELECT 
  traffic_source,
    COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS views,
    COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS cart,
    COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS stage_3_checkout,
    COUNT(DISTINCT CASE WHEN event_type = 'payment_info' THEN user_id END) AS stage_4_payment,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchase
  FROM user_events
  WHERE event_date >= (SELECT max (event_date)from user_events) - INTERVAL '30 days'
group BY
traffic_source)
select
traffic_source, 
views,
cart,
purchase,
round(cart*100 / views) as cart_conversion_rate,
round(purchase*100/cart) as cart_to_purchase_rate,
round(purchase*100/views) as overall_conversion_rate
  from
 source_funnel
 ORDER BY purchase desc