module Day1 where

import Data.List

main :: IO ()
main = do
  file <- readFile "input.txt"
  let l = lines file
  putStrLn $ "max: " ++ show (fetchThree l)

fetchThree :: [String] -> Int
fetchThree l = (sum . take 3 . reverse . sort) (calc l 0)

calc :: [String] -> Int -> [Int]
calc [] cur = []
calc ("":rest) cur = cur:calc rest 0
calc (carbs:rest) cur = calc rest $ cur + read carbs
