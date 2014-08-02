{-# LANGUAGE EmptyDataDecls    #-}
{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs             #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}

module Model where

import Yesod
import Data.Text (Text)
import Data.Time
import Database.Persist.Quasi
import Data.Typeable (Typeable)
import Prelude

import SqlSettings

share [mkPersist settings, mkMigrate "migrateAll"]
    $(persistFileWith lowerCaseSettings "config/models")
