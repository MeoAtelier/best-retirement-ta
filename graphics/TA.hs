{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

module TA where

import           Control.Monad                        (join)
import           Data.Aeson
import qualified Data.ByteString.Char8                as B
import           Database.PostgreSQL.Simple
import           Database.PostgreSQL.Simple.FromField
import           Database.PostgreSQL.Simple.SqlQQ
import           GHC.Generics

data TA = TA
  { name       :: String
  , rates      :: Int
  , sunshine   :: Int
  , burglary   :: Int
  , population :: Int
  , medical    :: Int
  , property   :: Int
  , overall    :: Int
  , geom       :: String
  } deriving (Show, Eq, Generic, FromRow, ToJSON)

ta =
  [sql|
select r.*, ST_AsSvg(geom)
from rank r
inner join ta2017_gv_clipped
  on ta = ta2017_nam
order by overall
;
|]

taSmallGeom =
  [sql|
with _b as (
select
  -1 * st_xmin(st_extent(geom)) as x,
  -1 * st_ymin(st_extent(geom)) as y
  from ta2017_gv_clipped
)
select r.*
  , st_assvg(st_simplify(st_scale(st_translate(geom,b.x,b.y),0.01,0.01),0.2),1,2)
from _b b, rank r
inner join ta2017_gv_clipped
  on ta = ta2017_nam
order by overall
;
|]

taNoGeom =
  [sql|
select r.*, ''::text
from rank r
inner join ta2017_gv_clipped
  on ta = ta2017_nam
order by overall
;
|]
