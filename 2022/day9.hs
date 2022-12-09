module Day9 where

import Data.List

type Point = (Int, Int)
type Action = Char

main :: IO ()
main = do
  file <- readFile "input.txt"
  let acts = concat $ fmap parseline (lines file)
  let (final, tailTrail) = logic (take 10 (repeat (1000,1000))) acts
  putStrLn $ (show (length $ nub (reverse tailTrail)))

parseline :: String -> [Action]
parseline (inst:' ':rest) = take (read rest::Int) (repeat inst)

logic :: [Point] -> [Action] -> ([Point], [Point])
logic knots acts = foldl step (knots, []) acts

step :: ([Point], [Point]) -> Action -> ([Point], [Point])
step (knots, tlhistory) act = (reverse newArr2, ((head newArr2):tlhistory))
  where nextHead = newhead (head knots) act
        newArr2 = foldl (\acc part ->
                           (newtl (head acc) part:acc)) [nextHead] (tail knots)

newhead :: Point -> Action -> Point
newhead (x, y) 'U' = (x, y-1)
newhead (x, y) 'D' = (x, y+1)
newhead (x, y) 'L' = (x-1, y)
newhead (x, y) 'R' = (x+1, y)

newtl :: Point -> Point -> Point
newtl (x, y) (a, b) = case (xdiff, ydiff) of
                        (2,2) -> diag  (x, y) (a, b)
                        (2,_) -> horiz (x, y) (a, b)
                        (_,2) -> vert  (x, y) (a, b)
                        _ -> (a, b)
  where xdiff = abs (x - a)
        ydiff = abs (y - b)

diag (x, y) (a, b) | x > a && y > b = (a+1, b+1)
                   | x < a && y < b = (a-1, b-1)
                   | x > a && y < b = (a+1, b-1)
                   | x < a && y > b = (a-1, b+1)

horiz (x, y) (a, b) | x > a = (a+1, y)
                    | x < a = (a-1, y)

vert (x, y) (a, b) | y > b = (x, b+1)
                   | y < b = (x, b-1)
