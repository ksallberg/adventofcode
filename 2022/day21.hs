module Day21 where

import Data.Set
import Data.List.Split
import Data.Maybe
import Numeric

data Monkey =
  Operation String String (Double -> Double -> Double) | Yell Double

main :: IO ()
main = do
  file <- readFile "input.txt"
  let parsed = fmap parseLine (lines file)
      firstTrue = loop 0 1 parsed
  putStrLn $ "pt2: " ++ (show (showFFloat Nothing firstTrue ""))

loop :: Double -> Double -> [(String, Monkey)] -> Double
loop x adder parsed = case getMonkey "root" x parsed of
                        (True, y, m1, m2) ->
                          y
                        (False, _, m1, m2) ->
                          case m1 > m2 of
                            -- talet måste öka
                            True ->
                              loop (x+adder * 2) (adder * 2) parsed
                              -- talet måste minska
                            False -> do
                              loop (x-adder / 2) (adder / 2) parsed

parseLine :: String -> (String, Monkey)
parseLine line = case rest2 of
                   [num] ->
                     (name, Yell (read num))
                   [m1, op, m2] ->
                     (name, Operation m1 m2 (parseOp op))
  where [name,rest] = splitOn ":" line
        rest2 = splitOn " " (tail rest)

parseOp :: String -> (Double -> Double -> Double)
parseOp "/" = (/)
parseOp "+" = (+)
parseOp "-" = (-)
parseOp "*" = (*)

getMonkey :: String -> Double -> [(String, Monkey)] ->
             (Bool, Double, Double, Double)
getMonkey "root" hooman monkeys = (monkey1 == monkey2, hooman, monkey1, monkey2)
  where Operation m1 m2 _ = fromJust $ lookup "root" monkeys
        monkey1 = getMonkey' m1 hooman monkeys
        monkey2 = getMonkey' m2 hooman monkeys

getMonkey' :: String -> Double -> [(String, Monkey)] -> Double
getMonkey' "humn" hooman monkeys = hooman
getMonkey' name hooman monkeys =
  case refMonkey of
    Yell num ->
      num
    Operation m1 m2 fun ->
      fun (getMonkey' m1 hooman monkeys)
          (getMonkey' m2 hooman monkeys)
  where refMonkey = fromJust $ lookup name monkeys
