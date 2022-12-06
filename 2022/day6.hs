module Day6 where

import Data.List

main :: IO ()
main = do
  file <- readFile "input.txt"
  putStrLn $ "res: " ++ show (find2 file 0)

find1 :: String -> Int -> Int
find1 (a:b:c:d:rest) count
  | a /= b && a /= c && a /= d && b /= c && b /= d && c /= d = count + 4
  | otherwise = find1 (b:c:d:rest) (count+1)


find2 :: String -> Int -> Int
find2 xs count = case a == b of
                   True ->
                     count + 14
                   False ->
                     find2 (tail xs) count+1
  where a = (take 14 xs)
        b = nub a
