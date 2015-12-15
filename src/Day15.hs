module Day15 where

import Data.List
import Data.List.Split

type Ingredient = (String, Int, Int, Int, Int, Int)

main :: IO ()
main = do
  f <- readFile "input.txt"
  let ings = map parse $ map (splitOn " ") (lines f)
      high = maximum [getScore x ings | x <- combs]
  putStrLn $ "Optimal: " ++ (show high)

combs :: [[Int]]
combs = [[x,y,z,w] | x <- [0..100],
                     y <- [0..100],
                     z <- [0..100],
                     w <- [0..100], x+y+z+w == 100]

mayb0 :: Int -> Int
mayb0 inp | inp < 0   = 0
          | otherwise = inp

getScore :: [Int] -> [Ingredient] -> Int
getScore [frosting, candy, butterscotch, sugar] ins =
  case calories == 500 of
      True  -> mayb0 capacity * mayb0 durability * mayb0 flavor * mayb0 texture
      False -> 0
  where (_, fcap, fdur, fflav, ftex, fcal) = getIngredient "Frosting:" ins
        (_, ccap, cdur, cflav, ctex, ccal) = getIngredient "Candy:" ins
        (_, bcap, bdur, bflav, btex, bcal) = getIngredient "Butterscotch:" ins
        (_, scap, sdur, sflav, stex, scal) = getIngredient "Sugar:" ins
        capacity =   fcap  * frosting +
                     ccap  * candy +
                     bcap  * butterscotch +
                     scap  * sugar
        durability = fdur  * frosting +
                     cdur  * candy +
                     bdur  * butterscotch +
                     sdur  * sugar
        flavor =     fflav * frosting +
                     cflav * candy +
                     bflav * butterscotch +
                     sflav * sugar
        texture =    ftex  * frosting +
                     ctex  * candy +
                     btex  * butterscotch +
                     stex  * sugar
        calories =   fcal  * frosting +
                     ccal  * candy +
                     bcal  * butterscotch +
                     scal  * sugar

getIngredient :: String -> [Ingredient] -> Ingredient
getIngredient name (y@(x, _, _, _, _, _):ys)
  | name == x = y
  | otherwise = getIngredient name ys

parse :: [String] -> Ingredient
parse [name, _cap, cap, _dur, dur, _flav, flav, _tex, tex, _cal, cal] =
  (name,
   read (init cap),
   read (init dur),
   read (init flav),
   read (init tex),
   read cal)
