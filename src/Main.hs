module Main where

import Prelude ()
import ClassyPrelude
import Arguments

main :: IO ()
main = run =<< readArgs

run :: RunArgs -> IO ()
run = undefined
