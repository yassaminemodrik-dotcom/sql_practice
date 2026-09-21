-- analyse the time spent by visitors in the funnel stages/ the time by minutes between the view phase and the purchse phase only for confirmed purchases
WITH time_conversion AS(SELECT
user_id,
min(CASE when event_type='page_view'then event_date END) AS view_time,
min( CASE WHEN event_type = 'add_to_cart' THEN event_date END) AS cart_time,

min(CASE WHEN event_type = 'purchase' THEN event_date end) as purchase_time
FROM user_events
WHERE event_date>=(select max(event_date)from user_events)-interval'30 days'
GROUP BY
user_id
having
min(CASE WHEN event_type = 'purchase' THEN event_date end)is not null)


select
count(*) as converted_users,
round (avg(EXTRACT(EPOCH FROM (cart_time - view_time)) / 60)) as avg_view_to_cart_minutes,
round(avg(EXTRACT(EPOCH FROM (purchase_time - cart_time)) / 60)) as avg_cart_to_purchase_minutes,
round(avg(EXTRACT(EPOCH FROM (purchase_time - view_time)) / 60)) as avg_view_to_purchase_minutes
from
time_conversion
