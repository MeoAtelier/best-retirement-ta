{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

module Export where

import           Control.Monad                        (join)
import           Data.Aeson
import qualified Data.ByteString.Char8                as B
import           Database.PostgreSQL.Simple
import           Database.PostgreSQL.Simple.FromField
import           Database.PostgreSQL.Simple.SqlQQ
import           GHC.Generics

data Export = Export
  { name            :: String
  , rates           :: Double
  , sunshine        :: Maybe Double
  , burglary        :: Double
  , over65pc        :: Double
  , over65pop       :: Double
  , dhbStaff        :: Double
  , seniorMedical   :: Double
  , juniorMedical   :: Double
  , careSupport     :: Double
  , nurses          :: Double
  , allied          :: Double
  , totalProperties :: Int
  , medianValue     :: Int
  , totalSales      :: Int
  , medianPrice     :: Int
  } deriving (Show, Eq, Generic, FromRow, ToJSON)

export =
  [sql|
    select r.ta
      , r.avg_rates::double precision
      , mean
      , burglary::double precision
      , over65_pc::double precision
      , over65_pop::double precision
      , all_staff::double precision
      , senior_medical::double precision
      , junior_medical::double precision
      , care_support::double precision
      , nurses::double precision
      , allied::double precision
      , total_properties::int
      , median_value::int
      , total_sales_in_2017::int
      , median_sales_price::int
from rates r
left join ta_sunshine s
  on r.ta = s.ta2017_nam
left join over65 o
  on lower(r.ta) = lower(o.ta)
left join healthcare_ta_percap h
  on r.ta = h.ta2017_label
left join two_bedroom p
  on r.ta = p.name
left join crime_percap c
  ON lower(r.ta) = lower(c.ta)
;
|]
