module Day20 where

import qualified Data.List as DL
import qualified Data.CircularList as DC

import Data.Maybe

data Dir = L | R
  deriving (Show, Eq)

main :: IO ()
main = do
  file <- readFile "input.txt"
  let parsed = fmap parseLine (lines file)
      circLs = DC.fromList (zip [0..] parsed)
      circLs2 = DC.fromList (zip [0..] (fmap (*811589153) parsed))
      pt1 = moveN 1 circLs
      pt2 = moveN 10 circLs2
      pt1Answer = pickNums pt1
      pt2Answer = pickNums pt2
  putStrLn $ "pt1: " ++ (show pt1Answer)
  putStrLn $ "pt2: " ++ (show pt2Answer)

pickNums :: DC.CList (Int, Integer) -> Integer
pickNums cl = elem1000 + elem2000 + elem3000
  where gotoZero = fromJust $ DC.findRotateTo (\(_, num) -> num == 0) cl
        (_, elem1000) = fromJust $ DC.focus (DC.rotN 1000 gotoZero)
        (_, elem2000) = fromJust $ DC.focus (DC.rotN 2000 gotoZero)
        (_, elem3000) = fromJust $ DC.focus (DC.rotN 3000 gotoZero)

-- nooooooooooooooo
moveN :: Int -> DC.CList (Int, Integer) -> DC.CList (Int, Integer)
moveN 0 input = input
moveN count input = moveN (count-1) (DC.fromList (zip [0..] ls))
  where moved = move [0..4999] input
        ls = fmap snd (DC.toList moved)

move :: [Int] -> DC.CList (Int, Integer) -> DC.CList (Int, Integer)
move [] cl = cl
move (i:is) cl = move is (move' (goto i cl))

move' :: DC.CList (Int, Integer) -> DC.CList (Int, Integer)
move' cl = DC.insertR elemToMove clMovedToInsertionPlace
  where elemToMove@(_, amount) = fromJust $ DC.focus cl
        clRemoved = DC.removeR cl
        newAmount = (fromIntegral (amount `mod` 4999))
        clMovedToInsertionPlace = DC.rotN newAmount clRemoved

goto :: Int -> DC.CList (Int, Integer) -> DC.CList (Int, Integer)
goto index cl = fromJust $ DC.findRotateTo (\(ind, num) -> index == ind) cl

parseLine :: String -> Integer
parseLine num = (read num)
