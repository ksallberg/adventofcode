module Day6 where

import Data.List

main :: IO ()
main = do
  f <- readFile "input"
  let x = map freq $ transpose $ lines f
      w = map snd $ map (head . reverse . sort) x
  putStrLn $ concat w

freq :: String -> [(Int, String)]
freq = map (\x->(length x, [head x])) . group . sort
