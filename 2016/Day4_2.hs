{-# LANGUAGE MultiWayIf #-}

module Day4_2 where

import Data.Char
import Data.List
import Data.List.Split

main :: IO ()
main = do
  f <- readFile "input.txt"
  let xFun = \line ->
                let (cipher, secId, _) = parseLine line
                in (caesar secId cipher, secId)
      mapped  = fmap xFun (lines f)
      filt    = filter (\x->fst x=="northpole object storage") mapped
  putStrLn (show filt)

parseLine :: String -> (String, Int, String)
parseLine inp = (encrypted, read sec :: Int, chk)
  where parsed    = parse inp
        encrypted = concat $ intersperse "-" (init parsed)
        sec       = sectorId (last parsed)
        chk       = checksum (last parsed)

checksum :: String -> String
checksum = init . (drop 1) . (dropWhile (/='['))

sectorId :: String -> String
sectorId = takeWhile (/='[')

parse :: String -> [String]
parse = splitOn "-"

caesarSh :: Char -> Char
caesarSh '-' = ' '
caesarSh 'z' = 'a'
caesarSh other = chr $ ord other + 1

caesar :: Int -> String -> String
caesar 0 x = x
caesar amount x = caesar (amount-1) (map caesarSh x)
