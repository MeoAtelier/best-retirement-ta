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

-- Assumes population is evenly spread ...
-- Which of course it isn't, but I think it is a reasonably approximation
CREATE OR REPLACE VIEW healthcare_ta_dhb AS
SELECT h.dhb
  , ta.ta2018_v_1 as ta
  , all_staff * overlap as all_staff
  , senior_medical * overlap as senior_medical
  , junior_medical * overlap as junior_medical
  , care_support * overlap as care_support
  , nurses * overlap as nurses
  , allied * overlap as allied
FROM healthcare_professionals_nominal h
INNER JOIN dhb_ta_overlap ta
  ON dhb2015_na = h.dhb
;

CREATE OR REPLACE VIEW healthcare_ta_percap AS
WITH _s AS (
  SELECT ta
  , sum(all_staff) as all_staff
  , sum(senior_medical) as senior_medical
  , sum(junior_medical) as junior_medical
  , sum(care_support) as care_support
  , sum(nurses) as nurses
  , sum(allied) as allied
FROM healthcare_ta_dhb
GROUP BY ta
)
SELECT _s.ta
  , all_staff / value * 100000 as all_staff
  , senior_medical / value * 100000 as senior_medical
  , junior_medical / value * 100000 as junior_medical
  , care_support / value * 100000 as care_support
  , nurses / value * 100000 as nurses
  , allied / value * 100000 as allied
FROM _s
INNER JOIN ta_pop ta
  ON lower(_s.ta) = lower(ta.area)
WHERE ta.year = '2016'
  AND ta.age = 'Total people, age'
;


COMMIT;
