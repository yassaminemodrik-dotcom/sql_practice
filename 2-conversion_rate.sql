--define the conversion rate through the funnel
WITH funnel_stages AS (
  SELECT 
    COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS stage_1_views,
    COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS stage_2_cart,
    COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS stage_3_checkout,
    COUNT(DISTINCT CASE WHEN event_type = 'payment_info' THEN user_id END) AS stage_4_payment,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS stage_5_purchase
  FROM user_events
  WHERE event_date >= (SELECT max (event_date)from user_events) - INTERVAL '30 days'
)
select
stage_1_views,
round(stage_2_cart*100 / stage_1_views) as view_to_cart_rate,
stage_2_cart,
round(stage_3_checkout*100/stage_2_cart) as cart_to_checkout_rate,
stage_3_checkout,
round(stage_4_payment*100/stage_3_checkout) as checkout_to_payment_rate,
stage_4_payment,
round(stage_5_purchase*100/stage_4_payment) as payment_to_purchase_rate,
stage_5_purchase,
round(stage_5_purchase*100/stage_1_views) as overall_conversion_rate
  from
  funnel_stages