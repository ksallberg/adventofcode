module Day4 where

import Data.List
import Data.List.Split

main :: IO ()
main = do
  file <- readFile "input.txt"
  let l = length $ filter (==True) ( map parseLine (lines file))
  putStrLn $ "hej" ++ (show l)

parseLine ls = let [a, b] = splitOn "," ls
                   spla = spl a
                   splb = spl b
               in (isSubsequenceOf spla splb || isSubsequenceOf splb spla)

spl x = let [a, b] = splitOn "-" x
        in ([read a :: Int .. read b :: Int])

-- pt 2

parseLine2 ls = let [a, b] = splitOn "," ls
                    spla = spl a
                    splb = spl b
                in (intersect spla splb /= [])
