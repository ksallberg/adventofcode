module Day9 where

import Data.List

type Point = (Int, Int)

data Action = U | D | L | R
  deriving (Show)

main :: IO ()
main = do
  file <- readFile "input.txt"
  let acts = concat $ fmap parseline (lines file)
  let (finalHd, finalTl, tailTrail) = logic (1000,1000) (1000,1000) acts
  putStrLn $ (show (length $ nub tailTrail))

parseline :: String -> [Action]
parseline (inst:' ':rest) = take (read rest::Int) (repeat (instToAction inst))
  where instToAction 'U' = U
        instToAction 'D' = D
        instToAction 'L' = L
        instToAction 'R' = R

logic :: Point -> Point -> [Action] -> (Point, Point, [Point])
logic hd tl acts = foldl step (hd, tl, []) acts

step :: (Point, Point, [Point]) -> Action -> (Point, Point, [Point])
step (hd, tl, tlhistory) act = (nextHead, nextTail, (nextTail:tlhistory))
  where nextHead = newhead hd act
        nextTail = newtl nextHead tl act

newhead :: Point -> Action -> Point
newhead (x, y) U = (x, y-1)
newhead (x, y) D = (x, y+1)
newhead (x, y) L = (x-1, y)
newhead (x, y) R = (x+1, y)

newtl :: Point -> Point -> Action -> Point
newtl (x, y) (a, b) act = case xdiff of
                            2 -> let (a2, b2) = newhead (a,b) act
                                 in (a2, y)
                            _ -> case ydiff of
                                   2 -> let (a2, b2) = newhead (a, b) act
                                        in (x, b2)
                                   _ -> (a, b)
  where xdiff = abs (x - a)
        ydiff = abs (y - b)
