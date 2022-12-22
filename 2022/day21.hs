module Day21 where

import Data.Set
import Data.List.Split
import Data.Maybe

data Monkey =
  Operation String String (Integer -> Integer -> Integer) | Yell Integer

main :: IO ()
main = do
  file <- readFile "input.txt"
  let parsed = fmap parseLine (lines file)
      -- root = getMonkey "root" parsed -- pt1
      -- tests = [getMonkey "root" hooman parsed | hooman <- [5000000..]]
      -- firstTrue = head $ dropWhile (\(bool, num) -> bool == False) tests
                             -- 3587647562851
      hmm = getMonkey "root" 3587647562854 parsed
      hmm2 = getMonkey "root" 3587647562851 parsed
  firstTrue <- loop 0 1 parsed
  putStrLn $ "hmm: " ++ (show hmm)
  putStrLn $ "hmm2: " ++ (show hmm2)
  putStrLn $ "pt2: " ++ (show firstTrue)

loop :: Integer -> Integer -> [(String, Monkey)] -> IO Integer
loop x adder parsed = case getMonkey "root" x parsed of
           (True, y, m1, m2) -> do
             putStrLn ("___FOUND THE RIGHT " ++ (show m1) ++ " "++ (show m2))
             return y
           (False, _, m1, m2) -> do
             putStrLn ("___adder" ++ show x ++ ", " ++ show adder ++
                       ", " ++ (show m1) ++ ", " ++ (show m2))
             case m1 > m2 of
               -- talet måste öka
               True -> do
                 putStrLn "öka"
                 let newAdder = adder * 2
                 loop (x+newAdder) newAdder parsed
               -- talet måste minska
               False -> do
                 putStrLn "minksa"
                 let newAdder = div adder 2
                 loop (x-newAdder) newAdder parsed

between :: Integer -> Integer -> Integer
between a b = div (a + b) 2

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

getMonkey ::
  String -> Integer -> [(String, Monkey)] -> (Bool, Integer, Integer, Integer)
getMonkey "root" hooman monkeys = (monkey1 == monkey2, hooman, monkey1, monkey2)
  where Operation m1 m2 _ = fromJust $ lookup "root" monkeys
        monkey1 = getMonkey' m1 hooman monkeys
        monkey2 = getMonkey' m2 hooman monkeys

getMonkey' :: String -> Integer -> [(String, Monkey)] -> Integer
getMonkey' "humn" hooman monkeys = hooman
getMonkey' name hooman monkeys = case refMonkey of
                                  Yell num ->
                                    num
                                  Operation m1 m2 fun ->
                                    fun (getMonkey' m1 hooman monkeys)
                                        (getMonkey' m2 hooman monkeys)
  where refMonkey = fromJust $ lookup name monkeys
