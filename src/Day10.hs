module Day10 where

import Control.Applicative
import Data.List
import Data.Maybe

main :: IO ()
main = putStrLn (show calc)

calc :: Int
calc = length $ step "1113122113"

step :: String -> String
step str = foldl (\acc _ ->
                    genNew (takeWords acc)) str [1..40]

genNew :: [String] -> String
genNew [] = ""
genNew (x:xs) = show (length x) ++ [head x] ++ genNew xs

takeWords :: String -> [String]
takeWords [] = []
takeWords (x:xs) =
    (x : (takeWhile (==x) xs)) : takeWords (dropWhile (==x) xs)

ti :: String -> Int
ti = read
