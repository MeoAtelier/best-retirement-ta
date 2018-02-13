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

flower ta = do
  let s1 = scl 0 $ 1 - (fromIntegral (rates ta) / 100)
      s2 = scl 60 $ 1 - (fromIntegral (sunshine ta) / 100)
      s3 = scl 120 $ 1 - (fromIntegral (burglary ta) / 100)
      s4 = scl 180 $ 1 - (fromIntegral (medical ta) / 100)
      s5 = scl 240 $ 1 - (fromIntegral (population ta) / 100)
      s6 = scl 300 $ 1 - (fromIntegral (property ta) / 100)
  S.g ! A.transform s1 $ petal "#7F2222"
  S.g ! A.transform s2 $ petal "#A05D43"
  S.g ! A.transform s3 $ petal "#F3F396"
  S.g ! A.transform s4 $ petal "#98DA7D"
  S.g ! A.transform s5 $ petal "#5188AE"
  S.g ! A.transform s6 $ petal "#172074"
  S.circle ! A.cx "0" ! A.cy "0" ! A.r "15" ! A.fill "#CCC"
  S.text_ ! A.x "0" ! A.y "140" ! A.textAnchor "middle" ! A.fontSize "20px" $
    S.string (name ta)
  where
    petal f = do
      S.path ! A.fill f ! A.d "M -12 -100 C -12 -120, 12 -120, 12 -100"
      S.path ! A.fill f ! A.d "M -12 -101 C -12 20, 12 20, 12 -101"
    scl r s =
      stringValue $
      "rotate(" ++ show r ++ "),scale(" ++ show s ++ "," ++ show s ++ ")"

main :: IO ()
main = do
  conn <- connectPostgreSQL "dbname=retirement"
  ta <- query_ conn ta
  taNoG <- query_ conn taNoGeom
  taSmallG <- query_ conn taSmallGeom
  doc overall overallColor "overall" ta
  doc overall overallColor "overall-small" taSmallG
  doc rates ratesColor "rates" ta
  doc sunshine sunshineColor "sunshine" ta
  doc burglary burglaryColor "burglary" ta
  doc population populationColor "population" ta
  doc medical medicalColor "medical" ta
  doc property propertyColor "property" ta
  BL.writeFile ("print" </> "flower.svg") $
    renderMarkup $
    S.docTypeSvg ! A.version "1.1" ! A.width "1000" ! A.height "2000" $
      forM_
        (zip taNoG ([0 ..] :: [Int]))
        (\(y, i) ->
           S.g ! A.id_ (stringValue $ name y) !
           A.transform
             (stringValue $
              "scale(0.6,0.6),translate(" ++
              show ((i `mod` 6) * 260 + 120) ++
              "," ++ show (300 * floor (fromIntegral i / 6) + 150) ++ ")") $
           flower y)
  BL.writeFile ("interactive" </> "src" </> "ranking-data.json") $ encode taNoG
  BL.writeFile ("interactive" </> "src" </> "map.json") $ encode taSmallG
  where
    doc acc col fn a =
      BL.writeFile ("print" </> fn ++ ".svg") $
      renderMarkup $
      S.docTypeSvg ! A.version "1.1" ! A.width "500" ! A.height "800" !
      A.viewbox "1088000 -6160000 1001950 1446320" $
      forM_ (map (colorMap acc col) a) geo
