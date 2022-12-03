module Day3 where

import Data.Char
import Data.List

main :: IO ()
main = do
  file <- readFile "input.txt"
  let l = lines file
  -- let mapped = fmap parseLine l
  -- putStrLn $ "sum: " ++ show (sum mapped)
  putStrLn $ "num2: " ++ show (pline l)

parseLine :: String -> Int
parseLine x = let (a, b) = Data.List.splitAt (div (length x) 2) x
              in patch (ord (head $ intersect a b))

patch :: Int -> Int
patch x | x >= 97 = x - 96
        | otherwise = x - 38

--pt2

pline :: [String] -> Int
pline (x:y:z:rest) = (patch badge) + pline rest
  where badge = ord . head $ intersect z (intersect x y)
pline [] = 0
