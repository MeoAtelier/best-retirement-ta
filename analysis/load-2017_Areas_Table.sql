BEGIN;

DROP TABLE IF EXISTS areas_table CASCADE;

CREATE TABLE areas_table (
    MB2001_code text
  , MB2006_code text
  , MB2010_code text
  , MB2011_code text
  , MB2013_code text
  , MB2016_code text
  , MB2017_code text
  , AU2013_code text
  , AU2013_label text
  , AU2017_code text
  , AU2017_label text
  , UA2017_code text
  , UA2017_label text
  , TA2010_code text
  , TA2010_label text
  , TA2017_code text
  , TA2017_label text
  , WARD2017_code text
  , WARD2017_label text
  , CB2017_code text
  , CB2017_label text
  , TASUB2017_code text
  , TASUB2017_label text
  , REGC2017_code text
  , REGC2017_label text
  , CON2017_code text
  , CON2017_label text
  , MCON2017_code text
  , MCON2017_label text
  , GED2014_code text
  , GED2014_label text
  , MED2014_code text
  , MED2014_label text
  , DHB2015_code text
  , DHB2015_label text
  , DHBCON2015_code text
  , DHBCON2015_label text
  , HDOM2013_code text
);

\copy areas_table from 'analysis/2017_Areas_Table.csv' with csv header

CREATE INDEX ON areas_table (au2017_code, ta2017_label);

CREATE VIEW ta_au_lookup AS
SELECT au2017_code || ' ' || au2017_label as au, ta2017_label
FROM areas_table
GROUP BY au2017_code, au2017_label, ta2017_label
;

COMMIT;
