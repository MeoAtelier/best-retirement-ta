BEGIN;

CREATE or replace view health_rank AS
WITH _r AS (
  SELECT ta2017_label
   , rank() over (order by all_staff desc) as all_staff
   , rank() over (order by senior_medical desc) as senior_medical
   , rank() over (order by junior_medical desc) as junior_medical
   , rank() over (order by care_support desc) as care_support
   , rank() over (order by nurses desc) as nurses
   , rank() over (order by allied desc) as allied
  FROM healthcare_ta_percap
)
select ta2017_label as ta, rank() over (order by all_staff * 2 + senior_medical + junior_medical + care_support + nurses + allied)
FROM _r;

create or replace view over65_rank as
with _inner as (
  select ta, rank() over (order by over65_pop desc) as pop, rank() over (order by over65_pc desc) as pc
  from over65
)
select ta, rank() over (order by pop + pc)
from _inner;

create or replace view rank as
with _inner AS (
select r.ta
  , rank() over (order by avg_rates) as rates
  , rank() over (order by mean) as sunshine
  , o.rank as over65
  , h.rank as health
from rates r
left join ta_sunshine s
  on r.ta = s.ta2017_nam
left join over65_rank o
  on lower(r.ta) = lower(o.ta)
left join health_rank h
  on r.ta = h.ta
)
select *, rank() over (order by rates + sunshine + over65 + health) as overall
from _inner
;




COMMIT;
