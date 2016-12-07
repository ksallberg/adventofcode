module Day7 where

main :: IO ()
main = do
  f <- readFile "input.txt"
  let treated = [treat line True "" ([], []) | line <- lines f]
      eval    = [(map isOk ok, map isOk nok) | (ok, nok) <- treated]
      oks     = filter (\(ok, nok)-> any (==True) ok && all (==False) nok) eval
  putStrLn $ show (length oks)

-- cur is being built up
treat :: String -> Bool -> String -> ([String], [String])
         -> ([String], [String])
treat []       True  cur (ok, nok) = (cur:ok, nok)
treat (']':xs) False cur (ok, nok) = treat xs True  ""      (ok, cur:nok)
treat ('[':xs) True  cur (ok, nok) = treat xs False ""      (cur:ok, nok)
treat (x:xs)   True  cur ret       = treat xs True  (x:cur) ret
treat (x:xs)   False cur ret       = treat xs False (x:cur) ret

isOk :: String -> Bool
isOk (a : b : c : d : rest) = (a == d && b == c && a /= b)
                              || (isOk (b : c : d : rest))
isOk _ = False
