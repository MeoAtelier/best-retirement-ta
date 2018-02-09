BEGIN;

DROP TABLE IF EXISTS two_bedroom  CASCADE;

CREATE TABLE two_bedroom (
    Code text
  , Name text
  , Total_Properties numeric
  , Median_Value numeric
  , Total_Sales_in_2017 numeric
  , Median_Sales_Price numeric
  , _blank text
);

\copy two_bedroom from 'analysis/two-bedroom.csv' with csv header

WITH _a AS (
  DELETE FROM two_bedroom
  WHERE name ~ 'Auckland.*'
  RETURNING *
)
INSERT INTO two_bedroom (name, total_properties, median_value, total_sales_in_2017, median_sales_price)
SELECT 'Auckland', sum(total_properties), round(avg(median_value)), sum(total_sales_in_2017), round(avg(median_sales_price))
FROM _a;

UPDATE two_bedroom
SET name = 'Lower Hutt City'
WHERE name = 'Hutt City';

UPDATE two_bedroom
SET name = 'Matamata-Piako District'
WHERE name = 'Matamata Piako District';

UPDATE two_bedroom
SET name = 'Mackenzie District'
WHERE name = 'MacKenzie District';

UPDATE two_bedroom
SET name = 'Thames-Coromandel District'
WHERE name = 'Thames Coromandel District';

UPDATE two_bedroom
SET name = 'Queenstown-Lakes District'
WHERE name = 'Queenstown Lakes District';

UPDATE two_bedroom
SET name = 'Central Hawke''s Bay District'
WHERE name = 'Central Hawkes Bay District';

COMMIT;
