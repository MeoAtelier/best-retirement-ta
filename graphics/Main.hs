{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Control.Monad                 (forM_)
import           Data.Aeson
import qualified Data.ByteString.Lazy          as BL
import           Data.Colour.Palette.BrewerSet
import           Data.Colour.SRGB
import           Data.List                     (groupBy)
import           Data.Monoid
import           Database.PostgreSQL.Simple
import           System.FilePath               ((</>))
import           Text.Blaze                    (stringValue)
import           Text.Blaze.Renderer.Utf8      (renderMarkup)
import           Text.Blaze.Svg11              (mkPath, translate, (!))
import qualified Text.Blaze.Svg11              as S
import qualified Text.Blaze.Svg11.Attributes   as A

import           TA

ratesColor = reverse $ brewerSet RdYlBu 11

sunshineColor = reverse $ brewerSet PuOr 11

burglaryColor = reverse $ brewerSet RdGy 11

populationColor = reverse $ brewerSet PRGn 11

medicalColor = reverse $ brewerSet PiYG 11

propertyColor = reverse $ brewerSet BrBG 11

overallColor = reverse $ brewerSet RdYlGn 11

colorMap :: (TA -> Int) -> [Kolor] -> TA -> (String, String, Kolor)
colorMap acc col ta
  | acc ta == 1 = go 0 ta col
  | acc ta <= 6 = go 1 ta col
  | acc ta <= 14 = go 2 ta col
  | acc ta <= 23 = go 3 ta col
  | acc ta <= 33 = go 4 ta col
  | acc ta <= 43 = go 6 ta col
  | acc ta <= 52 = go 7 ta col
  | acc ta <= 60 = go 8 ta col
  | acc ta <= 65 = go 9 ta col
  | otherwise = go 10 ta col
  where
    go i (TA n _ _ _ _ _ _ _ g) col = (n, g, col !! i)

geo (n, g, c) =
  S.path ! A.id_ (stringValue n) ! A.d (stringValue g) !
  A.fill (stringValue $ sRGB24show c)

main :: IO ()
main = do
  conn <- connectPostgreSQL "dbname=retirement"
  ta <- query_ conn ta
  doc overall overallColor "overall" ta
  doc rates ratesColor "rates" ta
  doc sunshine sunshineColor "sunshine" ta
  doc burglary burglaryColor "burglary" ta
  doc population populationColor "population" ta
  doc medical medicalColor "medical" ta
  doc property propertyColor "property" ta
  where
    doc acc col fn a =
      BL.writeFile ("print" </> fn ++ ".svg") $
      renderMarkup $
      S.docTypeSvg ! A.version "1.1" ! A.width "500" ! A.height "800" !
      A.viewbox "1088000 -6160000 1001950 1446320" $
      S.g $ forM_ (map (colorMap acc col) a) geo
