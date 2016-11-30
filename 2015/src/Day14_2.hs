module Day14_2 where

import Data.List
import Data.List.Split

type DeerInfo = (Int, String, Int, Int, Int)

main :: IO ()
main = do
  f <- readFile "input.txt"
  let deers     = map parse $ map (splitOn " ") (lines f)
      distAt    = [distanceAtTime d 1 | d <- deers]
      score     = foldl calc deers [1..2503]
      winner    = head ((reverse . sort) score)
  putStrLn $ "Optimal: " ++ show score
  putStrLn (show winner)
  putStrLn $ "Dist: " ++ (show distAt)

calc :: [DeerInfo] -> Int -> [DeerInfo]
calc deers sec = foldr incWinner deers winners
  where winners = getWinners deers sec

getWinners :: [DeerInfo] -> Int -> [String]
getWinners deers sec = map snd $ takeWhile (\x -> fst x == high) sorted
   where mapped = [(distanceAtTime d sec, name) | d@(_, name, _, _, _) <- deers]
         sorted   = reverse $ sort mapped
         high   = fst $ head sorted

incWinner :: String -> [DeerInfo] -> [DeerInfo]
incWinner name (x@(points, namex, a, b, c):xs)
  | name == namex = (points+1, namex, a, b, c) : xs
  | otherwise     = (x:incWinner name xs)

parse :: [String] -> DeerInfo
parse [name, _can, _fly, speed, _kms, _for, time, _seconds,
       _but, _then, _must, _rest, _for2, rest, _sec2] =
  (0, name, read speed, read time, read rest)

distanceAtTime :: DeerInfo -> Int -> Int
distanceAtTime deer@(_, _name, speed, time, rest) dur
    = sum $ take dur $ cycle $ activePeriod ++ restingPeriod
    where activePeriod  = take time (repeat speed)
          restingPeriod = take rest (repeat 0)
