
WITH funnel_revenue AS (
  SELECT 
    COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS total_visitors,
      COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS total_buyers,
    sum(CASE WHEN event_type = 'purchase' THEN amount END) AS total_revenue,
    COUNT( CASE WHEN event_type = 'purchase' THEN 1 END) AS total_orders
  
  FROM user_events
  WHERE event_date >= (SELECT max (event_date)from user_events) - INTERVAL '30 days')

select
total_visitors,
total_buyers,
total_revenue,
total_orders,
total_revenue/total_orders as avg_order_value,
total_revenue/total_buyers as revenue_per_buyer,
total_revenue/total_visitors as revenue_per_visitor
from funnel_revenue