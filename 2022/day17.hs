module Day17 where

import Control.Monad
import Data.Array
import Data.List.Split
import Debug.Trace

type Point = (Int, Int)
type Map = Array (Int, Int) Char
type Gas = String

data Rock = Horiz | Plus | J | Vert | Ball

roomHeight = 10000

main :: IO ()
main = do
  file <- readFile "input.txt"
  let map = floorFill $ listArray ((0,0), (6,roomHeight)) (repeat '.')
      gas = (concat . repeat) (head $ lines file)
      rocks = (concat . repeat) [Horiz, Plus, J, Vert, Ball]
  height <- loop 2022 map gas (roomHeight-3-(rockH (head rocks))) rocks
  putStrLn $ "final: " ++ (show (roomHeight-height))

loop :: Int -> Map -> Gas -> Int -> [Rock] -> IO Int
loop 0 map _ _ _ = return $ highestTower map
loop counter map gas spawnY (r:ocks) = do
  let newRockPos = (2, spawnY)
  (newMap, newGas) <- loop' newRockPos r map gas
  putStrLn $ "hightower" ++ (show (highestTower newMap))
  let newSpawnY = (highestTower newMap) - 3 - (rockH (head ocks))
  -- printSection newMap
  loop (counter-1) newMap newGas newSpawnY ocks

loop' :: Point -> Rock -> Map -> Gas -> IO (Map, Gas)
loop' rockPos@(x, y) rock map (g:a:s) = do
  let debugMap = updateMap map rockPos rock
  -- printSection debugMap
  case hitRock of
    True ->
      -- let (_, gasMovedP2) = doGas fallMovedP map a rock
      return (updateMap map fallMovedP rock, (a:s))
    False ->
      loop' fallMovedP rock map (a:s)
  where (_, gasMovedP) = doGas rockPos map g rock
        (hitRock, fallMovedP) = fall gasMovedP map rock

doGas :: Point -> Map -> Char -> Rock -> (Bool, Point)
doGas p map dir rock =
  case filter (\(x,y) -> x > 6 || x < 0) possibleCollissions of
    [] ->
      updateIfNoColls p map possibleCollissions (\(x,y) -> (x+move, y))
    _ ->
      (False, p)
  where move = case dir of
                 '>' -> 1
                 '<' -> (-1)
                 e -> error (show e)
        possibleCollissions = fmap (\(x,y) -> (x+move,y)) (getRockPoints p rock)

updateIfNoColls :: Point -> Map -> [Point] -> (Point -> Point) -> (Bool, Point)
updateIfNoColls p map colls updFun =
  case elem '#' [map ! coll | coll <- colls] of
    True ->
      (True, p)
    False ->
      (False, updFun p)

fall :: Point -> Map -> Rock -> (Bool, Point)
fall p@(x, y) map rock =
  -- all possible collission points must be '.'
  updateIfNoColls p map possibleCollissions (\(x,y) -> (x, y+1))
  where possibleCollissions = fmap (\(x,y) -> (x,y+1)) (getRockPoints p rock)

updateMap :: Map -> Point -> Rock -> Map
updateMap map p rock = map // pointsToInsert
  where pointsToInsert = zip (getRockPoints p rock) (repeat '#')

floorFill :: Map -> Map
floorFill map = map // pointsToInsert
  where pointsToInsert = zip [(x, roomHeight) | x <- [0..6]] (repeat '#')

getRockPoints :: Point -> Rock -> [Point]
getRockPoints (x, y) Horiz = [(x+inc, y) | inc <- [0..3]]
getRockPoints (x, y) Plus = (x+1,y+2):(x+1,y):[(x+inc, y+1) | inc <- [0..2]]
getRockPoints (x, y) J = (x, y+2):(x+1, y+2):[(x+2, y+inc) | inc <- [0..2]]
getRockPoints (x, y) Vert = [(x, y+inc) | inc <- [0..3]]
getRockPoints (x, y) Ball = [(x, y), (x+1, y), (x,y+1), (x+1,y+1)]

highestTower :: Map -> Int
highestTower map = highestTower' roomHeight map

highestTower' :: Int -> Map -> Int
highestTower' cnt map = case elem '#' checked of
                          False ->
                            cnt+1
                          True ->
                            highestTower' (cnt-1) map
  where checked = [map ! (x, cnt) | x <- [0..6]]

rockH :: Rock -> Int
rockH Horiz = 1
rockH Plus = 3
rockH J = 3
rockH Vert = 4
rockH Ball = 2

printSection :: Map -> IO ()
printSection map = do
  let clip = [(x, y) | y <- [(roomHeight-25)..roomHeight], x <- [0..6]]
      divide = chunksOf 7 clip
      strs = [fmap (\(x, y) -> map ! (x, y)) d | d <- divide]
  forM_ strs putStrLn
