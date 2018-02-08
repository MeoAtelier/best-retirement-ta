BEGIN;

DROP TABLE IF EXISTS ta_pop CASCADE;
CREATE TABLE ta_pop (
    area text
  , age text
  , sex text
  , year text
  , value numeric
  , flags text
);

CREATE INDEX ON ta_pop(area);

\copy ta_pop from 'analysis/population/ta.csv' with csv header

ANALYZE;

COMMIT;
