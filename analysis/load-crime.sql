BEGIN;

DROP TABLE IF EXISTS crime CASCADE;

CREATE TABLE crime (ta text, burglary numeric, theft numeric);

\copy crime from 'analysis/crime.csv' with csv header;

COMMIT;


