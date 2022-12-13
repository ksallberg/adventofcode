module Day13 where

import Data.Either
import Data.List
import Data.List.Split (chunksOf)
import Data.Maybe
import Text.ParserCombinators.Parsec

data Packet = Pack Int | Packets [Packet]
  deriving (Show, Eq)

instance Ord Packet where
  compare (Pack a) (Pack b) = compare a b
  compare x@(Pack a) y@(Packets b) = compare (Packets [x]) y
  compare x@(Packets a) y@(Pack b) = compare x (Packets [y])
  compare (Packets []) (Packets []) = EQ
  compare (Packets []) (Packets _)  = LT
  compare (Packets _ ) (Packets []) = GT
  compare x@(Packets (a:as)) y@(Packets (b:bs)) =
    case compare a b of
      EQ -> compare (Packets as) (Packets bs)
      other -> other

num :: Parser Packet
num = Pack <$> (read <$> many1 digit)

ls :: Parser Packet
ls = Packets <$> (char '[' *> (try ls <|> num) `sepBy` char ',') <* char ']'

main :: IO ()
main = do
  file <- readFile "input.txt"
  let x = chunksOf 2 (filter (/="") (lines file))
      y = fmap (\[a,b] ->
                   (fromRight (Pack 0) (parse ls "unknown" a),
                    fromRight (Pack 0) (parse ls "unknown" b))) x
  pt1 y
  pt2 y

pt1 :: [(Packet, Packet)] -> IO ()
pt1 input = do
  let counted = zip [1..] input
      filt = filter (\(count, (a,b)) -> a < b) counted
      total = sum (fmap fst filt)
  putStrLn $ "pt1: " ++ show total

pt2 :: [(Packet, Packet)] -> IO ()
pt2 input = do
  let tracer2 = Packets [Packets [Pack 2]]
      tracer6 = Packets [Packets [Pack 6]]
      lns = sort $ (tracer2:tracer6: concat [[a,b]|(a,b) <- input])
      res = (1 + (fromJust $ elemIndex tracer2 lns)) *
            (1 + (fromJust $ elemIndex tracer6 lns))
  putStrLn $ "pt2: " ++ show res
