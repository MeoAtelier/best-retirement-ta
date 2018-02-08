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

CREATE OR REPLACE VIEW healthcare_au AS
WITH _pop AS (
  SELECT au.*, p.value AS au_pop, d.value AS dhb_pop,
  p.value / d.value * overlap as weight
  FROM dhb_au_overlap au
  JOIN au_pop p
    ON au.au = p.area
  JOIN dhb_pop d
    ON au.dhb2015_na = d.area
  WHERE d.year = '2016'
    AND d.age = 'Total people, age'
)
SELECT h.dhb
  , a.au
  , a.au_pop
  , all_staff * weight as all_staff
  , senior_medical * weight as senior_medical
  , junior_medical * weight as junior_medical
  , care_support * weight as care_support
  , nurses * weight as nurses
  , allied * weight as allied
FROM _pop a
INNER JOIN healthcare_professionals_nominal h
  ON a.dhb2015_na = h.dhb
;

CREATE OR REPLACE VIEW healthcare_ta_nominal AS
SELECT ta2017_label
  , sum(all_staff) AS all_staff
  , sum(senior_medical) AS senior_medical
  , sum(junior_medical) AS junior_medical
  , sum(care_support) AS care_support
  , sum(nurses) AS nurses
  , sum(allied) AS allied
FROM healthcare_au a
INNER JOIN ta_au_lookup l
  ON a.au = l.au
GROUP BY ta2017_label
;

CREATE OR REPLACE VIEW healthcare_ta_percap AS
WITH _pop AS (
  SELECT area, value
  FROM ta_pop
  WHERE year = '2016' and age = 'Total people, age'
)
SELECT ta2017_label
  , round(all_staff / p.value::numeric * 100000) as all_staff
  , round(senior_medical / p.value::numeric * 100000) as senior_medical
  , round(junior_medical / p.value::numeric * 100000) as junior_medical
  , round(care_support / p.value::numeric * 100000) as care_support
  , round(nurses / p.value::numeric * 100000) as nurses
  , round(allied / p.value::numeric * 100000) as allied
FROM healthcare_ta_nominal
JOIN _pop p on lower(area) = lower(ta2017_label)
;

COMMIT;
