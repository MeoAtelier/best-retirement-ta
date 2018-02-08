BEGIN;

CREATE OR REPLACE VIEW healthcare_professionals_nominal AS
SELECT 
    p.dhb
  , p.all_staff * d.value / 100000 as all_staff
  , p.senior_medical * d.value / 100000 as senior_medical
  , p.junior_medical * d.value / 100000 as junior_medical
  , p.care_support * d.value / 100000 as care_support
  , p.nurses * d.value / 100000 as nurses
  , p.allied * d.value / 100000 as allied
  , d.value AS population
FROM healthcare_professionals p
LEFT JOIN dhb_pop d
  ON p.dhb = d.area
WHERE age = 'Total people, age'
AND year = '2016'
;

COMMIT;
