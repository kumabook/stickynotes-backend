{-# LANGUAGE OverloadedStrings #-}

import Control.Applicative ((<$>))
import System.Environment (getEnv)
import Web.Scotty as Scotty
import Web.PathPieces

import Database.Persist
import qualified Database.Persist.Postgresql as P
import Database.Persist.TH
import Data.Conduit

import Control.Monad.IO.Class
import Control.Monad.Trans

import Data.Monoid (mconcat)

import Data.Time.Clock
import Data.Time.Calendar
import qualified Data.ByteString

import Model

toKey :: String -> P.Key  entity
toKey x = P.Key $ P.toPersistValue $ toPathPiece x

toKeyVal x = (P.entityKey x, P.entityVal x)

runDB p action = liftIO $ P.runSqlPersistMPool action p

main :: IO ()
main = P.withPostgresqlPool "host=localhost dbname=stickynotes user=kumabook password= port=5432" 10 $ \pool -> do
    flip P.runSqlPersistMPool pool $ do
       P.runMigration migrateAll
    port <- read <$> getEnv("PORT")
    Scotty.scotty port $ do
      let db = runDB pool
      Scotty.get "/echo" $ do
                           html $ mconcat ["<h1>Sticky Notes Backend</h1>"]
      Scotty.get "/users" $ do
        users <- db $ P.selectList ([] :: [P.Filter User]) [Desc UserId, LimitTo 50]
        json $ users
      Scotty.get "/users/:uid/stickies" $ do
                           key <- toKey <$> Scotty.param "uid"
                           stickies <- db $ P.selectList [StickyUserId ==. key] []
                           json $ stickies
