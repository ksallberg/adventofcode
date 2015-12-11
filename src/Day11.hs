module Day10 where

import Control.Applicative
import Data.List
import Data.Maybe
import Data.Char

main :: String -> IO ()
main str = case (not $ contains str) && threeChain str && pairs str of
               True  -> putStrLn $ "finally: " ++ str
               False -> do putStrLn str
                           main (increase str)

increase :: String -> String
increase str = case las of
                   'z' -> increase' str
                   _   -> init str ++ [chr (ord las + 1)]
    where las = last str

increase' :: String -> String
increase' []         = []
increase' (a:'z':xs) = (chr (ord a + 1)) : 'a' : increase' xs
increase' (x:xs)     = x : increase' xs


threeChain :: String -> Bool
threeChain (x:y:z:xs) =
    case (xv == (yv-1)) && (yv == (zv-1)) of
         True  -> True
         False -> threeChain (y:z:xs)
    where xv = ord x
          yv = ord y
          zv = ord z
threeChain [_,_] = False

contains :: String -> Bool
contains str = elem 'i' str || elem 'o' str || elem 'l' str

pairs :: String -> Bool
pairs str = length (pairs' str) >= 2

pairs' :: String -> [String]
pairs' []  = []
pairs' [_] = []
pairs' (a:b:c) | a == b = [a,b] : pairs' c
               | otherwise = pairs' (b:c)
