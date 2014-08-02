{-# LANGUAGE TemplateHaskell   #-}

module SqlSettings ( settings ) where

import Database.Persist
import Database.Persist.TH
import Data.Maybe

settings :: MkPersistSettings
settings = sqlSettings
    { mpsEntityJSON = Just EntityJSON
      { entityToJSON = 'entityIdToJSON
      , entityFromJSON = 'entityIdFromJSON
    }
  }
