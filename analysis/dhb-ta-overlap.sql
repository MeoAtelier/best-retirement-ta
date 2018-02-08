BEGIN;

DROP MATERIALIZED VIEW IF EXISTS dhb_au_overlap CASCADE;

CREATE MATERIALIZED VIEW dhb_au_overlap AS
WITH _a AS (
SELECT 
    dhb2015_na
  , au2017 || ' ' || au2017_nam as au
  , round((st_area(st_intersection(au.geom, dhb.geom)) / (au.area_sq_km * 1e6))::numeric, 3) as overlap
FROM au2017_gv_clipped au
INNER JOIN "district-health-board-2015" dhb
ON ST_Intersects(au.geom, dhb.geom)
WHERE dhb2015_na != 'Area outside District Health Board'
)
SELECT *, rank() over (partition by au order by overlap)
FROM _a
where overlap > 0
;

COMMIT;

