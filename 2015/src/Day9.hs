module Day9 (main) where

import Control.Applicative
import Data.List
import Data.Maybe

main :: IO ()
main = putStrLn (show $ calc)

calc :: Int
calc = head $
       reverse $
       sort $
       map fromJust (filter (/=Nothing) (map step paths))

step :: [String] -> Maybe Int
step [a, b]   = case cost a b of
                    Nothing -> cost b a
                    x -> x
step (a:b:xs) = do
    let z = case cost a b of
                Nothing -> cost b a
                _       -> cost a b
    case z of
        Nothing -> Nothing
        Just m -> case step (b:xs) of
                      Nothing -> Nothing
                      Just n -> Just (m+n)

paths :: [[String]]
paths = permutations ["Faerun", "Tristram", "Tambi", "Norrath", "Snowdin",
                      "Straylight", "AlphaCentauri", "Arbre"]

cost :: String -> String -> Maybe Int
cost "Faerun" "Tristram" = Just 65
cost "Faerun" "Tambi" = Just 129
cost "Faerun" "Norrath" = Just 144
cost "Faerun" "Snowdin" = Just 71
cost "Faerun" "Straylight" = Just 137
cost "Faerun" "AlphaCentauri" = Just 3
cost "Faerun" "Arbre" = Just 149
cost "Tristram" "Tambi" = Just 63
cost "Tristram" "Norrath" = Just 4
cost "Tristram" "Snowdin" = Just 105
cost "Tristram" "Straylight" = Just 125
cost "Tristram" "AlphaCentauri" = Just 55
cost "Tristram" "Arbre" = Just 14
cost "Tambi" "Norrath" = Just 68
cost "Tambi" "Snowdin" = Just 52
cost "Tambi" "Straylight" = Just 65
cost "Tambi" "AlphaCentauri" = Just 22
cost "Tambi" "Arbre" = Just 143
cost "Norrath" "Snowdin" = Just 8
cost "Norrath" "Straylight" = Just 23
cost "Norrath" "AlphaCentauri" = Just 136
cost "Norrath" "Arbre" = Just 115
cost "Snowdin" "Straylight" = Just 101
cost "Snowdin" "AlphaCentauri" = Just 84
cost "Snowdin" "Arbre" = Just 96
cost "Straylight" "AlphaCentauri" = Just 107
cost "Straylight" "Arbre" = Just 14
cost "AlphaCentauri" "Arbre" = Just 46

cost _ _ = Nothing