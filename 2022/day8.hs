module Day8 where

import Data.Array
import Data.Char
import Data.List

len = 98
-- len = 4

main :: IO ()
main = do
  file <- readFile "input.txt"
  let oneline = map (digitToInt) ((concat . lines) file)
      arr = listArray ((0,0), (len,len)) oneline
      toQuery = [(x, y) | x <- [1..len-1], y <- [1..len-1]]
      max = last $ sort [scenic tree arr | tree <- toQuery]
      -- interior = length $ filter (==True) [queryTree tree arr | tree <- toQuery]
      -- exterior = ((len+1) * 4 - 4)
      -- sum = interior+exterior
  putStrLn $ (show max)

queryTree :: (Int, Int) -> Array (Int, Int) Int -> Bool
queryTree (col, row) trees = elem True [curTree > last (sort left),
                                        curTree > last (sort right),
                                        curTree > last (sort above),
                                        curTree > last (sort below)]
  where curTree = trees ! (row, col)
        left  = [height | ((row1, col1), height) <- assocs trees,
                  col1 < col && row1 == row]
        right = [height | ((row1, col1), height) <- assocs trees,
                  col1 > col && row1 == row]
        above = [height | ((row1, col1), height) <- assocs trees,
                  row1 < row && col1 == col]
        below = [height | ((row1, col1), height) <- assocs trees,
                  row1 > row && col1 == col]

--pt 2

scenic :: (Int, Int) -> Array (Int, Int) Int -> Int
scenic (col, row) trees = (prune curTree $ reverse above) *
                          (prune curTree $ below) *
                          (prune curTree $ reverse left) *
                          (prune curTree $ right)
  where curTree = trees ! (row, col)
        left  = [height | ((row1, col1), height) <- assocs trees,
                  col1 < col && row1 == row]
        right = [height | ((row1, col1), height) <- assocs trees,
                  col1 > col && row1 == row]
        above = [height | ((row1, col1), height) <- assocs trees,
                  row1 < row && col1 == col]
        below = [height | ((row1, col1), height) <- assocs trees,
                  row1 > row && col1 == col]

prune curH trees = length ((takeWhile (<curH) trees)) + more
  where more = case dropWhile (<curH) trees of
                 [] -> 0
                 _ -> 1
