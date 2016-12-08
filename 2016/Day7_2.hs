module Day7_2 where

import Data.List

main :: IO ()
main = do
  f <- readFile "input.txt"
  let treated = [treat line True "" ([], []) | line <- lines f]
      abas    = map concat [map isAba ok | (ok, _nok) <- treated]
      noks    = map snd treated
      babs    = [step2 ab n | (ab, n) <- zip abas noks]
      oks     = filter (==True) babs
  putStrLn $ show (length oks)

-- cur is being built up
treat :: String -> Bool -> String -> ([String], [String])
         -> ([String], [String])
treat []       True  cur (ok, nok) = (cur:ok, nok)
treat (']':xs) False cur (ok, nok) = treat xs True  ""      (ok, cur:nok)
treat ('[':xs) True  cur (ok, nok) = treat xs False ""      (cur:ok, nok)
treat (x:xs)   True  cur ret       = treat xs True  (x:cur) ret
treat (x:xs)   False cur ret       = treat xs False (x:cur) ret

isAba :: String -> [String]
isAba (a : b : c : rest) =
  case (a == c && a /= b) of
    False -> isAba (b : c : rest)
    True  -> [a,b,c] : (isAba (b : c : rest))
isAba _ = []

step2 :: [String] -> [String] -> Bool
step2 abas noks = or [(tr a) `isInfixOf` n | a <- abas, n <- noks]
   where tr :: String -> String
         tr [a,b,_] = [b,a,b]
