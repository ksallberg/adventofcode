module Day1

import Data.List
import Data.String
import System.File

total
getNum : String -> Nat
getNum x = case parsePositive x of
                Nothing => 0
                Just y => y

total
calc : List String -> Nat -> List Nat
calc [] cur = []
calc (""::rest) cur = cur::calc rest 0
calc (carbs::rest) cur = calc rest (cur + getNum carbs)

total
fetchThree : List String -> Nat
fetchThree l = (sum . take 3 . reverse . sort) (calc l 0)

main : IO ()
main = do
  file <- readFile "input.txt"
  case file of
    Right x =>
      let l = lines x in
      printLn ("max: " ++ show (fetchThree l))
    Left y =>
      printLn "Couldnt parse"
