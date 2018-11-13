module Decode exposing (..)

-- import Json.Decode.Pipeline exposing (required, optional, hardcoded)

import Json.Decode as JD exposing (Decoder, andThen, at, field, int, list, string)
import Models exposing (DataStore, Model, Post, PostHint(Image, Link, Unknown, Video), PostList, Route(..), SubReddit)


postHint : String -> Decoder PostHint
postHint hint =
    case hint of
        "rich:video" ->
            JD.succeed Video

        "image" ->
            JD.succeed Image

        "link" ->
            JD.succeed Link

        _ ->
            JD.succeed Unknown


justPosthint : Maybe String -> Decoder PostHint
justPosthint hint =
    case hint of
        Just hint ->
            postHint hint

        Nothing ->
            JD.succeed Unknown


postDecoder : Decoder Post
postDecoder =
    JD.map8 Post
        (field "id" string)
        (field "url" string)
        (field "permalink" string)
        (field "title" string)
        (field "ups" int)
        (JD.maybe (field "post_hint" string) |> andThen justPosthint)
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
