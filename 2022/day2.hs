module Day2 where

import Data.List

main :: IO ()
main = do
  file <- readFile "input.txt"
  let l = lines file
  let mapped = fmap parseLine2 l
  let res = foldl (\(x, y) (a, b) -> (x+a, y+b)) (0, 0) mapped
  putStrLn $ "max: " ++ show (res)


-- loss 0
-- draw 3
-- win 6

--a rock 1
--b paper 2
--c scissor 3

-- x rock 1
-- y paper 2
-- z scissor 3

loss = 0
draw = 3
win = 6

rock = 1
paper = 2
scissor = 3

parseLine :: String -> (Int, Int)
parseLine "A X" = (rock+draw, rock+draw)
parseLine "B X" = (paper+win, rock+loss)
parseLine "C X" = (scissor+loss, rock+win)
parseLine "A Y" = (rock+loss, paper+win)
parseLine "B Y" = (paper+draw, paper+draw)
parseLine "C Y" = (scissor+win, paper+loss)
parseLine "A Z" = (rock+win, scissor+loss)
parseLine "B Z" = (paper+loss, scissor+win)
parseLine "C Z" = (scissor+draw, scissor+draw)

--part2

-- x means you lose
-- y means draw
-- z means you win

--a rock 1
--b paper 2
--c scissor 3

parseLine2 :: String -> (Int, Int)
parseLine2 "A X" = (0, scissor+loss)
parseLine2 "B X" = (0, rock+loss)
parseLine2 "C X" = (0, paper+loss)
parseLine2 "A Y" = (0, rock+draw)
parseLine2 "B Y" = (0, paper+draw)
parseLine2 "C Y" = (0, scissor+draw)
parseLine2 "A Z" = (0, paper+win)
parseLine2 "B Z" = (0, scissor+win)
parseLine2 "C Z" = (0, rock+win)
