BEGIN;

DROP TABLE IF EXISTS dhb_pop CASCADE;
CREATE TABLE dhb_pop (
    area text
  , age text
  , sex text
  , year text
  , value numeric
  , flags text
);

CREATE INDEX ON dhb_pop(area);

\copy dhb_pop from 'analysis/population/dhb.csv' with csv header

ANALYZE;

COMMIT;
