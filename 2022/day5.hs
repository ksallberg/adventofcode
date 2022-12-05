module Day5 where

import Data.Maybe
import qualified Data.Map as M

type Stacks = M.Map Int String

stacks0 :: Stacks
stacks0 = M.fromList (zip [1..]
                          ["TVJWNRMS", "VCPQJDWB", "PRDHFJB", "DNMBPRF",
                           "BTPRVH", "TPBC", "LPRJB", "WBZTLSCN", "GSL"])

main :: IO ()
main = do
  file <- readFile "input.txt"
  let acc = M.toList $
              foldl (\acc instruction -> move acc instruction)
                    stacks0
                    (fmap pline (lines file))
  putStrLn $ "res: " ++ [head x|(_, x)<-acc]

pline :: String -> (Int, Int,Int)
pline ['m','o','v','e',' ',x,' ','f','r','o','m',' ',y,' ','t','o',' ',z] =
  (read [x], read [y], read [z])
pline ['m','o','v','e',' ',x1,x2,' ','f','r','o','m',' ',y,' ','t','o',' ',z] =
  (read [x1,x2], read [y], read [z])

move :: Stacks -> (Int, Int, Int) -> Stacks
move stacks (amount, from, to) =
  -- pt 1: reverse toMove
  let toMove = take amount $ fromJust (M.lookup from stacks)
      newFrom = M.updateWithKey (\_ a -> Just (drop amount a)) from stacks
  in M.updateWithKey (\_ a -> Just (toMove++a)) to newFrom
