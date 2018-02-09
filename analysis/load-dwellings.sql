BEGIN;

DROP TABLE  IF EXISTS dwellings CASCADE;
CREATE TABLE dwellings (ta text, count numeric);

\copy dwellings from 'analysis/dwellings.csv' DELIMITER ','

UPDATE dwellings
SET ta = 'Whanganui District' where ta = 'Wanganui District';

COMMIT;
