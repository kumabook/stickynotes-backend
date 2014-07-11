{-# LANGUAGE OverloadedStrings #-}
import Control.Applicative ((<$>))
import System.Environment (getEnv)
import Web.Scotty
import Data.Monoid (mconcat)

main = do
  port <- read <$> getEnv("PORT")
  scotty port $ do
     get "/:word" $ do
         html $ mconcat ["<h1>Sticky Notes Backend</h1>"]
