{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty

import Data.Monoid (mconcat)

main = scotty 3000 $ do
     get "/:word" $ do
         html $ mconcat ["<h1>Sticky Notes Backend</h1>"]
