module Laddain

import Data.String
import System.File

printSteps : List String -> IO ()
printSteps (x::xs) = do
  putStrLn x
  printSteps xs
printSteps [] =
  putStrLn ""

main : IO ()
main = do
  file <- readFile "input.txt"
  case file of
    Right content => do
      printLn "bra"
      printSteps (lines content)
    Left err => printLn "inte bra"
