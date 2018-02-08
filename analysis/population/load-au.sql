BEGIN;

DROP TABLE IF EXISTS au_pop CASCADE;
CREATE TABLE au_pop (
    area text
  , age text
  , sex text
  , year text
  , value numeric
  , flags text
);

CREATE INDEX ON au_pop(area);

\copy au_pop from 'analysis/population/au.csv' with csv header

ANALYZE;

COMMIT;
