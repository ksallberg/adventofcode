module Day6 where

import Data.List

main :: IO ()
main = do
  f <- readFile "input"
  let x = map snd $ map (head . reverse . sort) (map freq $ transpose $ lines f)
  putStrLn $ concat x

freq :: String -> [(Int, String)]
freq = map (\x->(length x, [head x])) . group . sort
