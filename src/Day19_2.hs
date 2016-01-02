module Day19 where

import Data.List
--import Data.List.Utils
import Data.Algorithms.KMP

inputStr :: String
inputStr =
  "ORnPBPMgArCaCaCaSiThCaCaSiThCaCaPBSiRnFArRnFArCaCaSiThCaCaSiThCaCaCaCaC" ++
  "aCaSiRnFYFArSiRnMgArCaSiRnPTiTiBFYPBFArSiRnCaSiRnTiRnFArSiAlArPTiBPTiRn" ++
  "CaSiAlArCaPTiTiBPMgYFArPTiRnFArSiRnCaCaFArRnCaFArCaSiRnSiRnMgArFYCaSiRn" ++
  "MgArCaCaSiThPRnFArPBCaSiRnMgArCaCaSiThCaSiRnTiMgArFArSiThSiThCaCaSiRnMg" ++
  "ArCaCaSiRnFArTiBPTiRnCaSiAlArCaPTiRnFArPBPBCaCaSiThCaPBSiThPRnFArSiThCa" ++
  "SiThCaSiThCaPTiBSiRnFYFArCaCaPRnFArPBCaCaPBSiRnTiRnFArCaPRnFArSiRnCaCaC" ++
  "aSiThCaRnCaFArYCaSiRnFArBCaCaCaSiThFArPBFArCaSiRnFArRnCaCaCaFArSiRnFArT" ++
  "iRnPMgArF"

ws = [
 "ThF",
 "ThRnFAr",
 "BCa",
 "TiB",
 "TiRnFAr",
 "CaCa",
 "PB",
 "PRnFAr",
 "SiRnFYFAr",
 "SiRnMgAr",
 "SiTh",
 "CaF",
 "PMg",
 "SiAl",
 "CRnAlAr",
 "CRnFYFYFAr",
 "CRnFYMgAr",
 "CRnMgYFAr",
 "HCa",
 "NRnFYFAr",
 "NRnMgAr",
 "NTh",
 "OB",
 "ORnFAr",
 "BF",
 "TiMg",
 "CRnFAr",
 "HSi",
 "CRnFYFAr",
 "CRnMgAr",
 "HP",
 "NRnFAr",
 "OTi",
 "CaP",
 "PTi",
 "SiRnFAr",
 "CaSi",
 "ThCa",
 "BP",
 "TiTi",
 "HF",
 "NAl",
 "OMg"]

trans :: String -> String
trans "ThF" = "Al"
trans "ThRnFAr" = "Al"
trans "BCa" = "B"
trans "TiB" = "B"
trans "TiRnFAr" = "B"
trans "CaCa" = "Ca"
trans "PB" = "Ca"
trans "PRnFAr" = "Ca"
trans "SiRnFYFAr" = "Ca"
trans "SiRnMgAr" = "Ca"
trans "SiTh" = "Ca"
trans "CaF" = "F"
trans "PMg" = "F"
trans "SiAl" = "F"
trans "CRnAlAr" = "H"
trans "CRnFYFYFAr" = "H"
trans "CRnFYMgAr" = "H"
trans "CRnMgYFAr" = "H"
trans "HCa" = "H"
trans "NRnFYFAr" = "H"
trans "NRnMgAr" = "H"
trans "NTh" = "H"
trans "OB" = "H"
trans "ORnFAr" = "H"
trans "BF" = "Mg"
trans "TiMg" = "Mg"
trans "CRnFAr" = "N"
trans "HSi" = "N"
trans "CRnFYFAr" = "O"
trans "CRnMgAr" = "O"
trans "HP" = "O"
trans "NRnFAr" = "O"
trans "OTi" = "O"
trans "CaP" = "P"
trans "PTi" = "P"
trans "SiRnFAr" = "P"
trans "CaSi" = "Si"
trans "ThCa" = "Th"
trans "BP" = "Ti"
trans "TiTi" = "Ti"
trans "HF" = "e"
trans "NAl" = "e"
trans "OMg" = "e"

step :: Int -> [String] -> IO Int
step counter xs
  | elem "e" xs = return counter
  | otherwise   = do
      putStrLn (show counter)
      step (counter+1)
           (concat [replace' w (trans w) x | x <- sort xs, w <- ws])

replace' :: String -> String -> String -> [String]
replace' toReplace replaceWith replaceIn =
  let indices = match (build toReplace) replaceIn
  in [replace1 replaceIn toReplace replaceWith i | i <- indices]

replace1 :: String -> String -> String -> Int -> String
replace1 source old new index =
  let a = take index source
      b = drop index source
      c = drop (length old) b
  in a ++ new ++ c

main :: IO ()
main = do
  val <- step 0 [inputStr]
  putStr $ show val
