module Day14 where

import Data.Array
import Control.Monad
import Data.List
import Data.List.Split

type Point = (Int, Int)
type Map = Array (Int, Int) Char

startx = 250
size = 750

inp = ["498,4 -> 498,6 -> 496,6",
       "503,4 -> 502,4 -> 502,9 -> 494,9"]

main :: IO ()
main = do
  file <- readFile "input.txt"
  let parsed = fmap parseLine (lines file)
      largestY = head $ reverse $ sort (map snd (concat parsed))
      arr = listArray ((startx,0), (size,largestY+2)) (repeat '.')
      flooR = [(startx,largestY+2), (size, largestY+2)]
      arrRock = foldl (\accMap ln -> rockIt ln accMap) arr (flooR:parsed)
  putStrLn $ "largestY: " ++ (show largestY)
  rounds <- manySand 0 largestY arrRock
  putStrLn $ "rounds" ++ (show (rounds+1))

parseLine :: String -> [(Int, Int)]
parseLine st = [(read a, read b) | [a,b] <- prep]
  where prep = fmap (splitOn ",") (splitOn " -> " st)

printSection :: Map -> IO ()
printSection map = do
  let clip = [(x, y) |y<-[0..9], x<-[494..503]]
      divide = chunksOf 10 clip
      strs = [fmap (\(x, y) -> map ! (x,y)) d | d <- divide]
  forM_ strs putStrLn

rockIt :: [(Int,Int)] -> Map -> Map
rockIt [(_,_)] map = map
rockIt ((a,b):(c,d):rest) map = rockIt ((c,d):rest) newMap
  where coords = [(x, y) | x<-[min a c..max a c], y<-[min b d..max b d]]
        newMap = foldl (\accMap pos -> accMap // [(pos, '#')]) map coords

manySand :: Int -> Int -> Map -> IO Int
manySand round abyssAt map = do
  (x, y, z) <- fillSand round abyssAt (500, 0) map
  case (x, y, z) of
    (False, newRound, newMap) -> do
      -- printSection newMap
      -- putStrLn $ "round: " ++ (show newRound)
      manySand (newRound+1) abyssAt newMap
    (True, newRound, _) ->
      return newRound

fillSand :: Int -> Int -> (Int, Int) -> Map -> IO (Bool, Int, Map)
fillSand round abyss pos@(x,y) map = do
  -- printSection map
  -- putStrLn $ "H" ++ (show pos) ++ (show nextType)
  case (spawnReached, nextBlocked, downLeftBlocked, downRightBlocked) of
    (True, True, True, True) ->
      return (True, round, map)
    (_, False, _, _) ->
      fillSand round abyss (x,y+1) map
    (_, _, False, _) ->
      fillSand round abyss (x-1,y+1) map
    (_, _, _, False) ->
      fillSand round abyss (x+1,y+1) map
    (_, True, True, True) ->
      return (False, round, map // [(pos, 'o')])
   where spawnReached = x == 500 && y == 0
         abyssReached = y >= abyss
         nextType = map ! (x, y+1)
         nextBlocked = isBlocked nextType
         downLeft = map ! (x-1,y+1)
         downLeftBlocked = isBlocked downLeft
         downRight = map ! (x+1,y+1)
         downRightBlocked = isBlocked downRight

isBlocked :: Char -> Bool
isBlocked 'o' = True
isBlocked '#' = True
isBlocked _ = False
