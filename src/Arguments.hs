module Arguments where

import Prelude ()
import ClassyPrelude
import Options.Applicative
import System.FilePath
import System.Directory

data RunOpts = RunOpts
  {
    optFilepath :: FilePath,
    optCommand :: Command
  }

data Command = FetchName FetchNameOpts | FetchVersion FetchVersionOpts

type FetchNameOpts = ()
type FetchVersionOpts = ()

readOpts :: IO RunOpts
readOpts = do
    myRunOpts <- myOpts
    customExecParser myPrefs (myInfo myRunOpts)
  where
    myPrefs = prefs $ disambiguate <> showHelpOnEmpty
    myInfo theOpts = info theOpts $
      progDesc "Reads data from the .cabal file" <>
      fullDesc <>
      footer "Provided by Robert Fischer (RobertFischer on GitHub)"

myOpts :: IO (Parser RunOpts)
myOpts = do
    filePathOpt <- readFilePathOpt
    return $ RunOpts <$> filePathOpt <*> hsubparser (fetchNameOpts <> fetchVersionOpts)
  where
    isCabalFile filepath = (takeExtension filepath) == ".cabal"
    readFilePathOpt = do
      pwdListing <- listDirectory "."
      relListing <- mapM makeRelativeToCurrentDirectory pwdListing
      let contents = filter isCabalFile relListing
      return $ strOption $ optionForContents contents
        where
          optionForContents [] =
            long "file" <> short 'f' <> help "File to parse" <> metavar "CABAL-FILE"
          optionForContents (f:_) = (optionForContents []) <> value f <> showDefault

fetchNameOpts :: Mod CommandFields Command
fetchNameOpts = command "name" $ info (pure $ FetchName ()) $ progDesc "Fetch the name of the project"

fetchVersionOpts :: Mod CommandFields Command
fetchVersionOpts = command "version" $ info (pure $ FetchVersion ()) $ progDesc "Fetch the version of the project"


