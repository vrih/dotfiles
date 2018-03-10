{-# OPTIONS_GHC -fno-warn-unused-do-bind #-}
{-# LANGUAGE Trustworthy #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE Rank2Types #-}


module Main where

import Control.Exception (catch)
import Control.Monad
-- import Control.Monad.IO.Class
import Data.List (sort)
import Data.Monoid
import DBus
import DBus.Client
import Data.Text
import qualified Data.Text.Lazy.IO as TLIO
import Data.Text.Lazy.Builder
import qualified Data.Text as T


data Song = Song Text Text deriving Show


renderSong :: Maybe Song -> Builder
renderSong (Just (Song a t)) = fromText a <> " - " <> fromText t
renderSong Nothing = ""

--main :: IO ()
main = do
  client <- connectSession


  let getBody :: MethodReturn -> Maybe Variant
      getBody = fromVariant . Prelude.head . methodReturnBody
      getMetadata :: Variant -> Maybe Dictionary
      getMetadata = fromVariant
      lookupByName :: String -> Dictionary -> Maybe Variant
      lookupByName q = lookup (toVariant q) . dictionaryItems
      artist :: Dictionary -> Maybe String
      artist m = lookupByName "xesam:artist" m >>= fromVariant >>= fromVariant >>= (fromVariant . Prelude.head . arrayItems)
      title :: Dictionary -> Maybe String
      title m = lookupByName "xesam:title" m >>= fromVariant >>= fromVariant

      reply :: IO MethodReturn
      reply = call_ client (methodCall "/org/mpris/MediaPlayer2" "org.freedesktop.DBus.Properties" "Get")
               { methodCallDestination = Just "org.mpris.MediaPlayer2.spotify",
             methodCallBody = [
               toVariant ("org.mpris.MediaPlayer2.Player" :: String) ,
               toVariant ("Metadata" :: String)
                              ]
           }
      showArtistInfo :: MethodReturn -> Maybe Song
      showArtistInfo r = do
        meta <- getBody r >>= getMetadata
        a <- artist meta
        t <- title meta
        return $ Song (T.pack a) (T.pack t)

  do
    song <- catch (liftM showArtistInfo reply) (\(_ :: ClientError) -> return Nothing)
    TLIO.putStrLn $ toLazyText $ renderSong song

--  mapM_ putStrLn (sort names)
