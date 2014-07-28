{-# LANGUAGE CPP #-}

module DBHelper where


import Control.Applicative ((<$>))
import Database.Persist
import qualified Database.Persist.Postgresql as P
import Data.Monoid ((<>))
import Data.Text.Encoding (encodeUtf8)
import Web.Heroku (dbConnParams)

import Control.Monad.IO.Class
import Control.Monad.Trans
import Control.Monad.Trans.Resource


import Model

--runDB :: MonadIO m => P.ConnectionPool -> P.SqlPersistT IO a -> m a
--runDB p action = liftIO $ P.runSqlPersistMPool action p

