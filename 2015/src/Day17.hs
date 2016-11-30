module Day17 where

import Data.List

main :: IO ()
main = do
  let sizes   = [43, 3, 4, 10, 21, 44, 4, 6, 47, 41, 34, 17,
                 17, 44, 36, 31, 46, 9, 27, 38]
      ls      = map length $ filter (\x -> sum x == 150) (subsequences sizes)
      correct = length $ elemIndices (minimum ls) ls
  putStrLn $ show correct
