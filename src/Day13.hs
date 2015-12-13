module Day13 where

import Data.List
import Data.List.Split

type Cost = (String, String, Int)

main :: IO ()
main = do
  f <- readFile "input.txt"
  let costs   = map parse $ map (splitOn " ") (lines f)
      people  = nub [from | (from, _, _) <- costs]
      perm    = map (\xs -> xs ++ [head xs]) (permutations people)
      prices  = [price p costs | p <- perm]
      optimal = head . reverse $ sort prices
  putStrLn $ "Optimal: " ++ show optimal

parse :: [String] -> Cost
parse (name : _ : "lose" : points : xs) =
  (name, init (last xs), (read points :: Int) * (-1))
parse (name : _ : "gain" : points : xs) =
  (name, init (last xs), read points :: Int)

price :: [String] -> [Cost] -> Int
price [] costs = 0
price [_] costs = 0
price (a:b:xs) costs = dir1 + dir2 + price (b:xs) costs
    where dir1 = getCost costs a b
          dir2 = getCost costs b a

getCost :: [Cost] -> String -> String -> Int
getCost ((a, b, c):xs) d e | a == d && b == e = c
                           | otherwise = getCost xs d e
