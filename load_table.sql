COPY user_events
FROM 'C:\Users\E L I T E B O O K\OneDrive\Desktop\sql_practice\user_events (1).csv'
DELIMITER ',' CSV HEADER;
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
SELECT*
FROM user_events
