module Day18 where

import qualified Data.List as Ls
import Data.List.Split
import Data.Set

type Point = (Int, Int, Int)

main :: IO ()
main = do
  file <- readFile "input.txt"
  let cubes = fmap pline (lines file)
      rock = fromList cubes
      air = flood (-30) 30 rock
  putStrLn $ "pt1: " ++ (show (sum [countFreeSides p rock | p <- cubes]))
  putStrLn $ "pt2: " ++ (show (sum [countFreeSides2 p air | p <- cubes]))

pline :: String -> Point
pline x = let [a,b,c] = splitOn "," x
          in (read a, read b, read c)

countFreeSides :: Point -> Set Point -> Int
countFreeSides p@(x,y,z) s =
  6 - (Ls.length $ Ls.filter (==True) [member n s | n <- (getNeighbours p)])

countFreeSides2 :: Point -> Set Point -> Int
countFreeSides2 p@(x,y,z) airs =
  (Ls.length $ Ls.filter (==True) [member n airs | n <- (getNeighbours p)])

getNeighbours :: Point -> [Point]
getNeighbours (x,y,z) = [left, right, below, above, closer, further]
  where left = (x-1,y,z)
        right = (x+1,y,z)
        below = (x,y+1,z)
        above = (x,y-1,z)
        closer = (x,y,z-1)
        further = (x,y,z+1)

flood :: Int -> Int -> Set Point -> Set Point
flood minp maxp rocks = flood' minp maxp [(minp, minp, minp)] empty rocks

flood' :: Int -> Int -> [Point] -> Set Point -> Set Point -> Set Point
flood' minp maxp [] air rock = air
flood' minp maxp (p:lookAt) air rock =
  case outOfBounds minp maxp p || member p rock || member p air of
    True ->
      flood' minp maxp lookAt air rock
    False ->
      flood' minp maxp (lookAt++(getNeighbours p)) (insert p air) rock

outOfBounds :: Int -> Int -> Point -> Bool
outOfBounds minp maxp (x,y,z) =
  (x > maxp || x < minp) || (y > maxp || y < minp) || (z > maxp || z < minp)
