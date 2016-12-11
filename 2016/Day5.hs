module Day5 where

import Data.Hash.MD5

secretKey :: String
secretKey = "wtnhxymk"

hashed :: Int -> String
hashed num = md5s (Str $ secretKey ++ show num)

main :: IO ()
main = do
  let ls    = take 8 (next 2231254)
      strs  = map hashed ls
      final = map (head . drop 5) strs
  putStrLn final

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
