module Day15 where

import Data.List.Split
import Data.Set as DS
import qualified Data.List as DL

import Debug.Trace

data Dir = U | D | Both

type Point = (Integer, Integer)
type RangePoint = (Integer, Integer, Integer)

main :: IO ()
main = do
  file <- readFile "input.txt"
  let parsed = fmap parseLine (lines file)
      (x,y) = evalDiamonds parsed parsed
  putStrLn (show (x*4000000+y))

parseLine :: String -> (Point, Point, Integer)
parseLine x = (s, b, distX + distY)
  where spaceSep = splitOn " " x
        firstX = init (parseLine' $ spaceSep !! 2)
        firstY = init (parseLine' $ spaceSep !! 3)
        sndX = init (parseLine' $ spaceSep !! 8)
        sndY = parseLine' $ spaceSep !! 9
        (s@(x1,y1), b@(x2,y2)) = ((read firstX, read firstY),
                                  (read sndX, read sndY))
        distX = abs (x1 - x2)
        distY = abs (y1 - y2)

parseLine' :: String -> String
parseLine' (_:'=':rest) = rest

evalDiamonds :: [(Point, Point, Integer)] -> [(Point, Point, Integer)] -> Point
evalDiamonds (this@(s,b,len):rest) parse =
  case evalDiamond this parse of
    Left False ->
      evalDiamonds rest parse
    Right (xfrom, xto, y) ->
      let pt1 = (xfrom ,y)
          pt2 = (xto ,y)
          pt1OK = evalPointToSensors pt1 parse
      in case pt1OK of
           True ->
             pt1
           False ->
             pt2

evalDiamond :: (Point, Point, Integer) ->
               [(Point, Point, Integer)] ->
               Either Bool RangePoint
evalDiamond (s, b, len) parse = case DS.null filtered of
                                  True ->
                                    trace ("eval diamond false:" ++ show s) (Left False)
                                  False ->
                                    Right (head $ DS.toList filtered)
  where map = sensorCoverage Both (s, len+1) DS.empty
        filterf = (\(xfrom, xto, y) ->
                     let pt1 = (xfrom ,y)
                         pt2 = (xto, y)
                         pt1OK = evalPointToSensors pt1 parse
                         pt2OK = evalPointToSensors pt2 parse
                     in (pt1OK || pt2OK))
        filtered = DS.filter filterf map

evalPointToSensors :: Point -> [(Point, Point, Integer)] -> Bool
evalPointToSensors p@(x,y) [] = x >= 0 && x <= 4000000 && y >= 0 && y <= 4000000
evalPointToSensors p@(x,y) (((sx, sy), b, l):ps) =
  case dist <= l of
    True ->
      False
    False ->
      evalPointToSensors p ps
  where distx = abs (x-sx)
        disty = abs (y-sy)
        dist = distx + disty

sensorCoverage :: Dir -> (Point, Integer) ->
                  DS.Set RangePoint ->
                  DS.Set RangePoint
sensorCoverage _ (p, 0) covered = covered
sensorCoverage U ((x,y), len) covered = sensorCoverage U ((x,y-1), len-1) row
  where row = DS.insert (x-len, x+len, y) covered
sensorCoverage D ((x,y), len) covered = sensorCoverage D ((x,y+1), len-1) row
  where row = DS.insert (x-len, x+len, y) covered
sensorCoverage Both ((x,y), len) covered =
  sensorCoverage D ((x,y+1), len-1) lessY
  where row = DS.insert (x-len, x+len, y) covered
        lessY = sensorCoverage U ((x,y-1), len-1) row
