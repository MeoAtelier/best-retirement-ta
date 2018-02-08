BEGIN;

DROP TABLE  IF EXISTS dwellings CASCADE;
CREATE TABLE dwellings (ta text, count numeric);

\copy dwellings from 'analysis/dwellings.csv' DELIMITER ','

COMMIT;
