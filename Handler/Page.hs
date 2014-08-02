{-# LANGUAGE QuasiQuotes, TemplateHaskell, TypeFamilies #-}
{-# LANGUAGE OverloadedStrings, GADTs, FlexibleContexts #-}
{-# LANGUAGE RecordWildCards   #-}

module Handler.Page where

import Database.Esqueleto hiding (Value)
import qualified Database.Persist.Postgresql as P
import Import hiding ((==.))
import qualified Yesod as Y ((==.))
import Data.Time


data PageRequest = PageRequest
    { reqName :: Text
    , reqUrl  :: Text
    } deriving (Show)

instance ToJSON PageRequest where
    toJSON PageRequest {..} = object
        [ "name" .= reqName
        , "url"  .= reqUrl
        ]

instance FromJSON PageRequest where
    parseJSON (Object o) = PageRequest
        <$> o .: "name"
        <*> o .: "url"
    parseJSON _ = fail "Invalid page request"

data PageResponse = PageResponse
    { resId         :: PageId
    , resName       :: Text
    , resUrl        :: Text
    , resResource   :: ResourceId
    , resCreated    :: UTCTime
    , resUpdated    :: UTCTime
    } deriving (Show)

instance ToJSON PageResponse where
    toJSON PageResponse {..} = object
        [ "id"         .= resId
        , "name"       .= resName
        , "url"        .= resUrl
        , "resource"   .= resResource
        , "created"    .= resCreated
        , "updated"    .= resUpdated
        ]

instance FromJSON PageResponse where
    parseJSON (Object o) = PageResponse
        <$> o .: "id"
        <*> o .: "name"
        <*> o .: "url"
        <*> o .: "resource"
        <*> o .: "created"
        <*> o .: "updated"
    parseJSON _ = fail "Invalid page response"

makePageResponse :: Entity Page -> Entity Resource -> PageResponse
makePageResponse p r =
    PageResponse pageKey
                 (pageName pageVal)
                 (resourceUrl resVal)
                 resKey
                 (pageCreated pageVal)
                 (pageUpdated pageVal)
    where pageKey = entityKey p
          pageVal = entityVal p
          resKey = entityKey r
          resVal = entityVal r

getPagesR :: UserId -> Handler Import.Value
getPagesR userId = do
  pages <- runDB $ select $
--                   from $ \page -> do
                   from $ \(p `InnerJoin ` r) -> do
                   where_ (p ^. PageUser ==. val userId)
                   on (p ^. PageResource ==. r ^. ResourceId)
                   return $ (p, r)
  returnJson $ map (\pair -> makePageResponse (fst pair) (snd pair)) pages
postPagesR :: UserId -> Handler Value
postPagesR userId = do
  pageRequest <- requireJsonBody :: Handler PageRequest
  time <- liftIO getCurrentTime
  let pageName = reqName pageRequest
  let pageUrl = reqUrl pageRequest

  resource <- runDB $ P.selectFirst [ResourceUrl Y.==. pageUrl] []
  resourceId <- case resource of
    Nothing -> do
      resourceId <- runDB $ P.insert $ Resource $ pageUrl
      return resourceId
    Just r -> do
      return $ entityKey r
  let page = Page userId (reqName pageRequest) resourceId time time
  pageId <- runDB $ P.insert page
  returnJson $ toJSON $ PageResponse pageId
                                     pageName
                                     pageUrl
                                     resourceId
                                     (pageCreated page)
                                     (pageUpdated page)
