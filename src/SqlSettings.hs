{-# LANGUAGE TemplateHaskell   #-}

module SqlSettings where

import Database.Persist
import Database.Persist.Postgresql
import Database.Persist.TH

settings :: MkPersistSettings
settings = sqlSettings
    { mpsEntityJSON = Just EntityJSON
      { entityToJSON = 'entityIdToJSON
      , entityFromJSON = 'entityIdFromJSON
    }
  }

