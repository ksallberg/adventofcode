module Day19 where

import Data.List

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

trans "Al" = ["ThF", "ThRnFAr"]
trans "B"  = ["BCa", "TiB", "TiRnFAr"]
trans "Ca" = ["CaCa", "PB", "PRnFAr", "SiRnFYFAr", "SiRnMgAr", "SiTh"]
trans "F"  = ["CaF", "PMg", "SiAl"]
trans "H"  = ["CRnAlAr", "CRnFYFYFAr", "CRnFYMgAr", "CRnMgYFAr", "HCa",
              "NRnFYFAr", "NRnMgAr", "NTh", "OB", "ORnFAr"]
trans "Mg" = ["BF", "TiMg"]
trans "N"  = ["CRnFAr", "HSi"]
trans "O"  = ["CRnFYFAr", "CRnMgAr", "HP", "NRnFAr", "OTi"]
trans "P"  = ["CaP", "PTi", "SiRnFAr"]
trans "Si" = ["CaSi"]
trans "Th" = ["ThCa"]
trans "Ti" = ["BP", "TiTi"]
trans "e"  = ["HF", "NAl", "OMg"]
trans x    = [x]

iter :: String -> String -> [String]
iter old (cur:[])    = [old ++ x | x <- trans [cur]]
iter old (c:c2:next) =
   [old ++ x ++ (c2:next) | x <- trans [c]]     ++
   [old ++ x ++ next      | x <- trans [c, c2]] ++
   iter (old ++ [c]) (c2:next)

main :: IO ()
main = putStrLn . show . length . nub $ filter (/=inputStr) $ iter "" inputStr
