
\copy (select * from healthcare_ta_percap) to 'analysis/results/healthcare-ta.csv' with csv header

\copy (select * from rates) to 'analysis/results/rates.csv' with csv header

\copy (select * from over65) to 'analysis/results/over65.csv' with csv header

\copy (select * from ta_sunshine) to 'analysis/results/sunshine.csv' with csv header

