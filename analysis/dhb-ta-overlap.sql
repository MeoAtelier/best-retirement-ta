BEGIN;

DROP MATERIALIZED VIEW IF EXISTS dhb_ta_overlap;

CREATE MATERIALIZED VIEW dhb_ta_overlap AS
SELECT dhb2015_na, ta2018_v_1, rank() over (PARTITION BY dhb.gid ORDER BY ta.area_sq_km / ST_Area(dhb.geom) * 1e6),
  ta.area_sq_km / ST_Area(dhb.geom) * 1e6 as overlap

FROM "territorial-authority-2018-clipped-generalised" ta
INNER JOIN "district-health-board-2015" dhb
ON ST_Intersects(ta.geom, dhb.geom)
WHERE dhb2015_na != 'Area outside District Health Board'
  AND ta2018_v_1 != 'Area Outside Territorial Authority'
  ;


COMMIT;

