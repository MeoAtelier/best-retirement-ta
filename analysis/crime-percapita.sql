BEGIN;

CREATE OR REPLACE VIEW crime_percap AS
SELECT c.ta, round(c.burglary / value * 100000) AS burglary
FROM crime c
LEFT join ta_pop p
  ON lower(c.ta) = lower(p.area)
WHERE age = 'Total people, age'
  AND year = '2017'
  ;

COMMIT;
