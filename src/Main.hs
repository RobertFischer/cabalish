module Main where

import Prelude ()
import ClassyPrelude
import Arguments
import System.FilePath (FilePath)
import Distribution.Package
import Distribution.PackageDescription
import Distribution.PackageDescription.Parse (readPackageDescription)
import Distribution.Version (Version(..))
import Distribution.Verbosity (verbose)
import qualified Data.Text as T

main :: IO ()
main = run =<< readOpts

run :: RunOpts -> IO ()
run opts = case optCommand opts of
             FetchName fetchOpts -> runFetchName filepath fetchOpts
             FetchVersion fetchOpts -> runFetchVersion filepath fetchOpts
  where
    filepath = optFilepath opts

runFetchName :: FilePath -> FetchNameOpts -> IO ()
runFetchName filepath _ = do
  pkgDesc <- readCabalFile filepath
  let name = unPackageName $ pkgName $ package pkgDesc
  putStr $ T.pack name

runFetchVersion :: FilePath -> FetchVersionOpts -> IO ()
runFetchVersion filepath _ = do
  pkgDesc <- readCabalFile filepath
  let version = intercalate "." $ map show $ versionBranch $ pkgVersion $ package pkgDesc
  putStr $ T.pack version

readCabalFile :: FilePath -> IO PackageDescription
readCabalFile filepath = packageDescription <$> readPackageDescription verbose filepath
