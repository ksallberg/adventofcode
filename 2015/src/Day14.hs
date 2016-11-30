module Day14 where

import Data.List
import Data.List.Split

type DeerInfo = (String, Int, Int, Int)

main :: IO ()
main = do
  f <- readFile "input.txt"
  let deers     = map parse $ map (splitOn " ") (lines f)
      distances = sort [distance d 2503 | d <- deers]
  putStrLn $ "Optimal: " ++ show distances

parse :: [String] -> DeerInfo
parse [name, _can, _fly, speed, _kms, _for, time, _seconds,
       _but, _then, _must, _rest, _for2, rest, _sec2] =
  (name, read speed, read time, read rest)

distance :: DeerInfo -> Int -> Int
distance deer@(_name, speed, time, rest) dur
  | dur < 0 = 0
  | dur - time < 0 = time - dur * speed
  | otherwise = speed * time + distance deer (dur - (time + rest))
