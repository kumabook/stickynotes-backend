{-# LANGUAGE EmptyDataDecls    #-}
{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs             #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE TypeFamilies      #-}

module Model where

import Control.Monad.IO.Class  (liftIO)
import Database.Persist
import Database.Persist.Postgresql
import Database.Persist.TH
import Data.Text (Text)
import Data.Time (UTCTime)

import SqlSettings


share [mkPersist settings, mkMigrate "migrateAll"] [persistLowerCase|

User json
    email    Text
    password Text
    created  UTCTime default=now()
    updated  UTCTime default=now()
    deriving Show
Sticky json
    userId   UserId
    pageId   PageId
    content  Text
    x        Int
    y        Int
    width    Int
    height   Int
    color    Text
    created  UTCTime default=now()
    updated  UTCTime default=now()
    deriving Show
Resource json
    url      Text
    deriving Show
Page json
    userId     UserId
    resourceId ResourceId
    title      Text
    created    UTCTime default=now()
    updated    UTCTime default=now()
    deriving   Show
Tag json
    name     Text
    created  UTCTime default=now()
    updated  UTCTime default=now()
    deriving Show
StickyTag
    stickyId        StickyId
    tagId           TagId
    UniqueStickyTag stickyId tagId
|]

