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
             FetchName _ -> runFetchName filepath
             FetchVersion _ -> runFetchVersion filepath
  where
    filepath = optFilepath opts

fromPkgDesc :: (PackageDescription -> String) -> FilePath -> IO ()
fromPkgDesc f filepath = do
  pkgDesc <- readCabalFile filepath
  let result = f pkgDesc
  putStr $ T.pack name

runFetchName :: FilePath -> IO ()
runFetchName = fromPkgDesc $ \pkgDesc ->
  unPackageName $ pkgName $ package pkgDesc

runFetchVersion :: FilePath -> IO ()
runFetchVersion = fromPkgDesc $ \pkgDesc ->
  intercalate "." $ map show $ versionBranch $ pkgVersion $ package pkgDesc

readCabalFile :: FilePath -> IO PackageDescription
readCabalFile filepath = packageDescription <$> readPackageDescription verbose filepath
