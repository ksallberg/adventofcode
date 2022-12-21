module Day21 where

import Data.Set
import Data.List.Split
import Data.Maybe

data Monkey = Operation String String (Integer -> Integer -> Integer) | Yell Integer

main :: IO ()
main = do
  file <- readFile "input.txt"
  let parsed = fmap parseLine (lines file)
      root = getMonkey "root" parsed
  putStrLn $ "pt1: " ++ (show root)

parseLine :: String -> (String, Monkey)
parseLine line = case rest2 of
                   [num] ->
                     (name, Yell (read num))
                   [m1, op, m2] ->
                     (name, Operation m1 m2 (parseOp op))
  where [name,rest] = splitOn ":" line
        rest2 = splitOn " " (tail rest)

parseOp :: String -> (Integer -> Integer -> Integer)
parseOp "/" = (div)
parseOp "+" = (+)
parseOp "-" = (-)
parseOp "*" = (*)

getMonkey :: String -> [(String, Monkey)] -> Integer
getMonkey name monkeys = case refMonkey of
                           Yell num ->
                             num
                           Operation m1 m2 fun ->
                             fun (getMonkey m1 monkeys) (getMonkey m2 monkeys)
  where refMonkey = fromJust $ lookup name monkeys
