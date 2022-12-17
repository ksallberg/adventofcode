module Day7 where

import Control.Lens
import Control.Monad
import Data.List (sort)
import Data.List.Split

data Direction = Up | Down String
  deriving (Show)

data Action = Cd Direction | Ls | LsDir String | LsFile String Integer
  deriving (Show)

data FileSystem = Dir String [FileSystem] | File String Integer
  deriving (Show)

type Path = [String]

main :: IO ()
main = do
  file <- readFile "input.txt"
  let actions = fmap parseLine (lines file)
      fs = run (Dir "/" []) ["/"] (tail actions)
      allSums = map snd (sumdirs' fs)
      sums = (sum . filter (<100000)) allSums
      topLevelSum = sumdirs fs
      currentlyAvailable = 70000000 - topLevelSum
      toDelete = 30000000 - currentlyAvailable
  -- pt 1
  putStrLn $ "pt1: " ++ (show sums)
  -- pt 2
  putStrLn $ "pt2: " ++ (show (head . sort $ filter (>= toDelete) allSums))
  -- pprint fs 0

parseLine :: String -> Action
parseLine "$ cd .." = Cd Up
parseLine ('$':' ':'c':'d':' ':path) = Cd (Down path)
parseLine "$ ls" = Ls
parseLine ('d':'i':'r':' ':dir) = LsDir dir
parseLine str = LsFile name (read size)
  where [size, name] = splitOn " " str

run :: FileSystem -> Path -> [Action] -> FileSystem
run fs path [] = fs
run fs path ((Cd Up):actions) = run fs (init path) actions
run fs path ((Cd (Down name)):actions) = run fs (path++[name]) actions
run fs path (Ls:actions) = run fs path actions
run fs path ((LsDir name):actions) =
  run (create path fs (Dir name [])) path actions
run fs path ((LsFile name size):actions) =
  run (create path fs (File name size)) path actions

-- only supports the happy case: that all folders in path exist
create :: Path -> FileSystem -> FileSystem -> FileSystem
create (_:xs) cur@(Dir name chs) newFs =
  case (hasSubdir cur xs) of
    Just (pos, y@(Dir name2 chs2)) ->
      Dir name (chs & ix pos .~ create xs y newFs)
    Nothing ->
      Dir name (newFs:chs)

-- non recursive subdir check:
hasSubdir :: FileSystem -> Path -> Maybe (Int, FileSystem)
hasSubdir _ [] = Nothing
hasSubdir (Dir _name chs) (search:_) =
  case [(pos, x) | (pos, x@(Dir str _)) <- zip [0..] chs, str == search] of
    [] ->
      Nothing
    [(pos, (Dir a b))] ->
      Just (pos, (Dir a b))

-- just sum everything under a certain directory
sumdirs :: FileSystem -> Integer
sumdirs (Dir name chs) = files + dirs
  where files = sum [size | File _ size <- chs]
        dirs = sum [sumdirs d | d@(Dir _ _) <- chs]

-- traverse the tree, collect all directories, and sum
-- everything under each directory
sumdirs' :: FileSystem -> [(String, Integer)]
sumdirs' d@(Dir name chs) = (name, sumdirs d) : dirs
  where dirs = concat [sumdirs' d2|d2@(Dir _ _) <- chs]

-- tests:
test1 = create ["/"] (Dir "a" []) (Dir "/" [])
test2 = create ["/"] (Dir "b" []) test1
test3 = create ["/"] (Dir "c" []) test2
test4 = create ["/","c"] (Dir "c_child_1" []) test3
test5 = create ["/","c"] (Dir "c_child_2" []) test4
test6 = create ["/","c"] test5 (File "apa.html" 200)
test7 = create ["/","c","c_child_1"] test6 (File "bepa.html" 500)

-- pretty printer
pprint :: FileSystem -> Int -> IO ()
pprint (File name size) indent =
  putStr (take indent (repeat ' ')) >>
  putStrLn ("- " ++ name ++ ", (file, size=" ++ (show size) ++ ")")
pprint (Dir name chs) indent =
  putStr (take indent (repeat ' ')) >>
  putStrLn ("- " ++ name ++ " (dir)") >>
  forM_ chs (\ch -> pprint ch (indent + 2))
