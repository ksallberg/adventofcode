{-# LANGUAGE MultiWayIf #-}

module Day4 where

import Data.List
import Data.List.Split
import Data.Map hiding (foldl)

main :: IO ()
main = do
  f <- readFile "input.txt"
  let foldFun = (\acc ele ->
                   acc + isOk ele)
      theSum  = foldl foldFun 0 (lines f)
  putStrLn $ show theSum

parseLine :: String -> ([String], String, String)
parseLine inp = (init parsed, sec, chk)
  where parsed  = parse inp
        sec     = sectorId (last parsed)
        chk     = checksum (last parsed)

checksum :: String -> String
checksum = init . (drop 1) . (dropWhile (/='['))

sectorId :: String -> String
sectorId = takeWhile (/='[')

parse :: String -> [String]
parse = splitOn "-"

freq :: String -> [(Char, Int)]
freq inp = toList $ fromListWith (+) [(c, 1) | c <- inp]

isOk :: String -> Int
isOk inp =
  case eval ('_', 999999) chksum fr of
  True ->
    read secId :: Int
  False ->
    0
  where (chnks, secId, chksum) = parseLine inp
        fr = freq (concat chnks)

eval :: (Char, Int) -> String -> [(Char, Int)] -> Bool
eval _ [] _ = True
eval (prevc, previ) str ls =
  if | searchLs == []
       -> False
     | previ > snd cur
       -> eval cur (tail str) ls
     | previ == snd cur && prevCless
       -> eval cur (tail str) ls
     | otherwise ->
       False
  where searchLs = [l | l <- ls, fst l == head str]
        cur = head searchLs
        prevCless = prevc < fst cur
