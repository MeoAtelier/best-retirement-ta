BEGIN;

DROP TABLE IF EXISTS total_rates CASCADE;

CREATE TABLE total_rates (
    ta text
  , y1993 numeric
  , y1994 numeric
  , y1995 numeric
  , y1996 numeric
  , y1997 numeric
  , y1998 numeric
  , y1999 numeric
  , y2000 numeric
  , y2001 numeric
  , y2002 numeric
  , y2003 numeric
  , y2004 numeric
  , y2005 numeric
  , y2006 numeric
  , y2007 numeric
  , y2008 numeric
  , y2009 numeric
  , y2010 numeric
  , y2011 numeric
  , y2012 numeric
  , y2013 numeric
  , y2014 numeric
  , y2015 numeric
  , y2016 numeric)
;

\copy total_rates from 'analysis/rates.csv' with csv header NULL '..'

UPDATE total_rates
SET ta = 'Queenstown-Lakes District' WHERE ta = 'Queenstown Lakes District Council';

UPDATE total_rates
SET ta = 'Central Hawke''s Bay District' WHERE ta = 'Central Hawkes Bay District Council';

UPDATE total_rates
SET ta = 'Wanganui District' WHERE ta = 'Whanganui District Council';

UPDATE total_rates
SET ta = 'Lower Hutt City' WHERE ta = 'Hutt City Council';


COMMIT;
