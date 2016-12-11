module Day5_2 where

import Data.Char (digitToInt)
import Data.List
import Data.Hash.MD5

secretKey :: String
secretKey = "wtnhxymk"

hashed :: Int -> String
hashed num = md5s (Str $ secretKey ++ show num)

main :: IO ()
main = do
  let ls        = collect 0 []
      final     = map snd (sort ls)
  putStrLn (show (sort ls))
  putStrLn final

extract :: String -> (Int, Char)
extract (_:_:_:_:_:pos:ch:_) = (digitToInt pos, ch)

mine :: Int -> Int
mine inp = let try = hashed inp in
    case take 5 try of
        "00000" ->
            inp
        _ ->
            mine (inp+1)

next :: Int -> [Int]
next inp = let new = mine inp
           in new : next (new+1)

collect :: Int -> [Int] -> [(Int, Char)]
collect root [0,1,2,3,4,5,6,7] = []
collect root inp =
  let [num] = take 1 (next root)
      (pos, val) = extract (hashed num)
  in case elem pos inp of
    False ->
      case elem pos [0..7] of
        True ->
          (pos, val) : collect (num+1) (sort $ pos:inp)
        False ->
          collect (num+1) inp
    True ->
      collect (num+1) inp
