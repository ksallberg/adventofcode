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
      beacons = DS.fromList (fmap (\(s,b,l) -> b) parsed)
      sensorMap = coverSensors parsed
      ln10 = coverageAtY sensorMap beacons 2000000
  putStrLn (show (length ln10))

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

coverSensors :: [(Point, Point, Integer)] -> DS.Set RangePoint
coverSensors input = DL.foldl' accFun DS.empty input
  where accFun = (\accCov (s, b, len) -> sensorCoverage Both (s, len) accCov)

sensorCoverage :: Dir -> (Point, Integer) ->
                  DS.Set RangePoint ->
                  DS.Set RangePoint
sensorCoverage _ (p, 0) covered = covered
sensorCoverage U ((x,y), len) covered = sensorCoverage U ((x,y-1), len-1) row
  where row = case y of
                -- ugh
                2000000 ->
                  DS.insert (x-len, x+len, y) covered
                _ ->
                  covered
sensorCoverage D ((x,y), len) covered = sensorCoverage D ((x,y+1), len-1) row
  where row = case y of
                -- ugh
                2000000 ->
                  DS.insert (x-len, x+len, y) covered
                _ ->
                  covered
sensorCoverage Both ((x,y), len) covered =
  sensorCoverage D ((x,y+1), len-1) lessY
  where row = DS.insert (x-len, x+len, y) covered
        lessY = sensorCoverage U ((x,y-1), len-1) row

coverageAtY :: DS.Set RangePoint ->
               DS.Set Point ->
               Integer ->
               [(Integer, Integer)]
coverageAtY map beacons y = DS.toList (DS.difference expanded beacons)
  where filtered = DS.filter (\(mFrom, mTo, my) -> my == y) map
        expanded = DS.fromList (concat [zip [from..to] (repeat y)
                                       | (from, to, y) <- (DS.toList filtered)])
