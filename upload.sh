#!/bin/sh

aws s3 cp --recursive analysis/rates/ s3://data.newsapps.nz/data/best-retirement-area/ \
  --acl=public-read --cache-control max-age=2592000,public --exclude "*DS_Store"

aws s3 cp analysis/crime.csv s3://data.newsapps.nz/data/best-retirement-area/ \
  --acl=public-read --cache-control max-age=2592000,public --exclude "*DS_Store"

aws s3 cp analysis/population/TABLECODE7502_Data_9020e02b-f4ab-4585-8f88-31df25edc974.csv s3://data.newsapps.nz/data/best-retirement-area/ \
  --acl=public-read --cache-control max-age=2592000,public --exclude "*DS_Store"

aws s3 cp analysis/population/TABLECODE7509_Data_2a83a026-d55e-4a9b-9fea-29dcb037dd98.csv s3://data.newsapps.nz/data/best-retirement-area/ \
  --acl=public-read --cache-control max-age=2592000,public --exclude "*DS_Store"

aws s3 cp analysis/population/TABLECODE7502_Data_50c3f259-7cb0-4c27-a889-93aa4577ae57.csv s3://data.newsapps.nz/data/best-retirement-area/ \
  --acl=public-read --cache-control max-age=2592000,public --exclude "*DS_Store"

aws s3 cp --recursive analysis/DHB/ s3://data.newsapps.nz/data/best-retirement-area/ \
  --acl=public-read --cache-control max-age=2592000,public --exclude "*DS_Store"

aws s3 cp analysis/main.html s3://data.newsapps.nz/data/best-retirement-area/index.html \
  --acl=public-read --cache-control max-age=0,public --exclude "*DS_Store"
