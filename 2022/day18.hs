module Day18 where

import qualified Data.List as Ls
import Data.List.Split
import Data.Set

type Point = (Int, Int, Int)

main :: IO ()
main = do
  file <- readFile "input.txt"
  let cubes = fmap pline (lines file)
      setCubes = fromList cubes
      counted = [countFreeSides p setCubes | p <- cubes]
  putStrLn $ "pt1: " ++ (show (sum counted))
  putStrLn $ "pt2: " ++ "hej"

pline :: String -> Point
pline x = let [a,b,c] = splitOn "," x
          in (read a, read b, read c)

countFreeSides :: Point -> Set Point -> Int
countFreeSides (x,y,z) s =
  6 - (Ls.length $ Ls.filter (==True) [member n s|n <- neighbours])
  where neighbours = [left, right, below, above, closer, further]
        left = (x-1,y,z)
        right = (x+1,y,z)
        below = (x,y+1,z)
        above = (x,y-1,z)
        closer = (x,y,z-1)
        further = (x,y,z+1)
