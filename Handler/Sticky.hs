{-# LANGUAGE TupleSections, OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
module Handler.Sticky where

import Database.Esqueleto hiding (Value)
import Data.Time
import qualified Database.Persist.Postgresql as P
import Import hiding ((==.))

data StickyRequest = StickyRequest
    { reqContent :: Text
    , reqX       :: Int
    , reqY       :: Int
    , reqWidth   :: Int
    , reqHeight  :: Int
    , reqColor   :: Text
    , reqCreated :: UTCTime
    , reqUpdated :: UTCTime
    , reqPage    :: Page
    , reqTags    :: [Tag]
    } deriving (Show)
instance FromJSON StickyRequest where
    parseJSON (Object o) = StickyRequest
        <$> o .: "content"
        <*> o .: "x"
        <*> o .: "y"
        <*> o .: "width"
        <*> o .: "height"
        <*> o .: "color"
        <*> o .: "created"
        <*> o .: "updated"
        <*> o .: "page"
        <*> o .: "tags"
    parseJSON _ = fail "Invalid sticky request"

data StickyResponse = StickyResponse
    { resCode    :: Text
    , resMessage :: Text
    } deriving (Show)

instance ToJSON StickyResponse where
    toJSON StickyResponse {..} = object
         [ "code"    .= resCode
         , "message" .= resMessage
         ]

getStickiesR :: UserId -> Handler Value
getStickiesR userId = do
  stickies <- runDB $ select $
                      from $ \(s `InnerJoin ` st  `InnerJoin` t `InnerJoin` p) -> do
                      where_ (s ^. StickyUser ==. val userId)
                      on (s ^. StickyPage ==. p ^. PageId)
                      on (st ^. StickyTagTag ==. t ^. TagId)
                      on (s ^. StickyId ==. st ^. StickyTagSticky)
                      return $ (s, t, p)
  returnJson stickies

postStickiesR :: UserId -> Handler Value
postStickiesR userId = do
--  sticky <- requireJsonBody :: Handler StickyRequest
--  let tags = reqTags sticky
--  let page = reqPage sticky
--  tagIds =  create tags
--  pageId = -- create page
--  sticky = ToStickyFromStickyRequest
--  stickyId <- runDB $ P.insert sticky
  returnJson $ StickyResponse "200" "ok"


--  stickies <- runDB $ P.selectList ([] :: [P.Filter Sticky]) []
--  returnJson stickies
