BEGIN;
DROP TABLE IF EXISTS rates CASCADE;
CREATE TABLE rates AS
SELECT d.ta, round(r.y2016 * 1e3 / d.count) as avg_rates
FROM dwellings d
JOIN total_rates r
  ON lower(d.ta) = lower(replace(r.ta, ' Council', ''))
;

COMMIT;
