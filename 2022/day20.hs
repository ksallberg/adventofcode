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
      x = move [0..(length parsed)-1] circLs
      gotoZero = fromJust $ DC.findRotateTo (\(_, num) -> num == 0) x
      (_, elem1000) = fromJust $ DC.focus (DC.rotN 1000 gotoZero)
      (_, elem2000) = fromJust $ DC.focus (DC.rotN 2000 gotoZero)
      (_, elem3000) = fromJust $ DC.focus (DC.rotN 3000 gotoZero)
      added = elem1000 + elem2000 + elem3000
  putStrLn $ "pt1: " ++ (show added)

-- nooooooooooooooo
-- moveOne :: DC.CList (Int, Int) -> DC.CList (Int, Int)
-- moveOne input = DC.fromList (zip [0..] ls)
--   where moved = move [0..(length ls)-1] input
--         ls = fmap snd (DC.toList moved)

move :: [Int] -> DC.CList (Int, Int) -> DC.CList (Int, Int)
move [] cl = cl
move (i:is) cl = move is (move' (goto i cl))

move' :: DC.CList (Int, Int) -> DC.CList (Int, Int)
move' cl = DC.insertR elemToMove clMovedToInsertionPlace
  where elemToMove@(_, amount) = fromJust $ DC.focus cl
        clRemoved = DC.removeR cl
        clMovedToInsertionPlace = DC.rotN amount clRemoved

goto :: Int -> DC.CList (Int, Int) -> DC.CList (Int, Int)
goto index cl = fromJust $ DC.findRotateTo (\(ind, num) -> index == ind) cl

parseLine :: String -> Int
parseLine num = (read num)
