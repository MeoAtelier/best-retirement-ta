BEGIN;


drop materialized view if exists ta_sunshine cascade;
create materialized view ta_sunshine as 
with _s as (
  select ta2017_nam, st_summarystats(st_clip(rast, geom)) as stats
  from ta2017_gv_clipped, sunshine
)
select ta2017_nam, round((stats).mean) as mean
FROM _s
WHERE ta2017_nam != 'Area Outside Territorial Authority'
;


COMMIT;
