module Day16pt2 where

import Data.List.Split

type Line = (String, [(String, Int)])

main :: IO ()
main = do
  f <- readFile "input.txt"
  let lns = map parse $ map (splitOn " ") (lines f)
      fxs = [(adjust "children"    (==3)),
             (adjust "cats"        (>7)),
             (adjust "samoyeds"    (==2)),
             (adjust "pomeranians" (<3)),
             (adjust "akitas"      (==0)),
             (adjust "vizslas"     (==0)),
             (adjust "goldfish"    (<5)),
             (adjust "trees"       (>3)),
             (adjust "cars"        (==2)),
             (adjust "perfumes"    (==1))]
      final = foldl (\acc x -> filter x acc) lns fxs
  putStrLn $ "Optimal: " ++ show final

adjust :: String -> (Int -> Bool) -> Line -> Bool
adjust str b (numb, xs) =
  case lookup str xs of
      Nothing  -> True
      Just cat -> b cat

parse :: [String] -> Line
parse [_name,numb,pt1,pt1v,pt2,pt2v,pt3,pt3v] =
  (numb, [(init pt1, read $ init pt1v),
          (init pt2, read $ init pt2v),
          (init pt3, read pt3v)])
