module Decode exposing (..)

import Json.Decode as JD exposing (Decoder, at, field, int, list, map3, string)
import Models exposing (DataStore, Model, Post, PostList, Route(..), SubReddit)


postDecoder : Decoder Post
postDecoder =
    JD.map8 Post
        (field "id" string)
        (field "url" string)
        (field "permalink" string)
        (field "title" string)
        (field "ups" int)
        (JD.maybe (field "post_hint" string))
        (JD.maybe (at [ "preview", "images" ] <| JD.index 0 <| at [ "source", "url" ] string))
        (JD.maybe (at [ "media", "oembed", "thumbnail_url" ] string))


postsDecoder : Decoder PostList
postsDecoder =
    at [ "data" ] postDecoder
        |> JD.list


dataDecoder : Decoder DataStore
dataDecoder =
    at [ "data" ] <|
        JD.map3 DataStore
            (JD.maybe (field "after" string))
            (JD.maybe (field "before" string))
            (field "children" postsDecoder)
