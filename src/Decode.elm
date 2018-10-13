module Decode exposing (..)

import Json.Decode as JD exposing (Decoder, at, field, int, list, string)
import Models exposing (DataStore, Model, Post, PostHint, PostList, Route(..), SubReddit)


postHint : String -> Decoder PostHint
postHint hint =
    case hint of
        "rich:video" ->
            JD.succeed Models.RichVideo

        "image" ->
            JD.succeed Models.Image

        "link" ->
            JD.succeed Models.Link

        _ ->
            JD.succeed Models.Unknown


justPosthint : Maybe String -> Decoder PostHint
justPosthint hint =
    case hint of
        Just hint ->
            postHint hint

        Nothing ->
            JD.succeed Models.Unknown


postHintDecoder : Decoder PostHint
postHintDecoder =
    JD.maybe (field "post_hint" string) |> JD.andThen justPosthint


postDecoder : Decoder Post
postDecoder =
    JD.map8 Post
        (field "id" string)
        (field "url" string)
        (field "permalink" string)
        (field "title" string)
        (field "ups" int)
        postHintDecoder
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
