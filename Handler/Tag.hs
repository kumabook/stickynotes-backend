{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Tag where

import qualified Database.Persist.Postgresql as P
import Import

getTagsR :: UserId -> Handler Value
getTagsR userId = do
  tags <- runDB $ P.selectList ([] :: [P.Filter Tag]) []
  returnJson tags
