module Day10 where

import Control.Monad
import Data.List
import Data.List.Split

main :: IO ()
main = do
  file <- readFile "input.txt"
  let ops = fmap parseline (lines file)
  let (_, saved) = pt1 ops
      s2 = zip [1..] (drop 2 (reverse saved))
      parts = chunksOf 40 s2
  forM_ parts printl

parseline :: String -> (Int -> Int)
parseline ('a':'d':'d':'x':' ':rest) = (+) (read rest :: Int)
parseline "noop" = id

pt1 :: [(Int -> Int)] -> (Int, [Int])
pt1 ops = foldl (\(curx, save) op ->
                    let nextx = op curx
                    in case nextx == curx of
                      True ->
                        (nextx, (nextx:save))
                      False ->
                        (nextx, (nextx:curx:save)))
          (1, [1,1]) ops

printl :: [(Int, Int)] -> IO ()
printl x = forM_ x (\(cycle, x) -> printPixel cycle x) >> putStrLn ""

printPixel :: Int -> Int -> IO ()
printPixel cycle x = do
  let position = cycle `mod` 40
  case abs (position - x) > 1 of
    True ->
      putStr "."
    False ->
      putStr "#"
