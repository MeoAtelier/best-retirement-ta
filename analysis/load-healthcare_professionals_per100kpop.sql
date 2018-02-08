BEGIN;

DROP TABLE IF EXISTS healthcare_professionals CASCADE;

CREATE TABLE healthcare_professionals (
    dhb text
  , all_staff numeric
  , senior_medical numeric
  , junior_medical numeric
  , care_support numeric
  , nurses numeric
  , allied numeric
);

\copy healthcare_professionals from 'analysis/healthcare_professionals_per100kpop.csv' with csv header

COMMIT;
