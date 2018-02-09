BEGIN;

CREATE OR REPLACE VIEW over65 AS
SELECT r.area as ta, r.value as over65_pop, round(r.value / t.value * 100,1) as over65_pc
FROM ta_pop r
JOIN ta_pop t
  ON r.area = t.area
  AND r.year = t.year
JOIN rates rr ON
  lower(rr.ta) = lower(t.area) -- JUST filter out boards 
WHERE r.age = '65 years and over'
  AND t.age = 'Total people, age'
  AND r.year = '2016'
;

COMMIT;
