module Decode exposing (flagsDecoder, postDecoder, postsDecoder)

import Json.Decode as JD exposing (Decoder, andThen, bool, index, int, keyValuePairs, list, map2, string)
import Json.Decode.Pipeline exposing (optional, required)
import Models exposing (Flags, Post, PostHint(..), PostList, Response, SearchHistory, Settings)


postHintDecoder : Decoder PostHint
postHintDecoder =
    string
        |> JD.andThen
            (\str ->
                case str of
                    "rich:video" ->
                        JD.succeed Gif

                    "link" ->
                        JD.succeed Link

                    "image" ->
                        JD.succeed Image

                    _ ->
                        JD.succeed Unknown
            )


postDecoder : Decoder Post
postDecoder =
    JD.succeed Post
        |> required "id" string
        |> optional "preview" string ""
        |> required "permalink" string
        |> required "title" string
        |> required "ups" int
        |> optional "post_hint" postHintDecoder Unknown
        |> optional "preview" string ""
        |> optional "media_embed" string ""
        |> optional "url" string ""


postsDecoder : Decoder Response
postsDecoder =
    JD.succeed Response
        |> required "children" (JD.list postDecoder)
        |> optional "after" string ""
        |> optional "before" string ""
        |> optional "subreddit" string ""


settingsDecoder : Decoder Settings
settingsDecoder =
    JD.succeed Settings
        |> optional "count" string "10"
        |> optional "gifMode" bool False
        |> optional "imageMode" bool True
        |> optional "autoPlayGif" bool False
        |> optional "adultMode" bool False


flagsDecoder : Decoder Flags
flagsDecoder =
    JD.succeed Flags
        |> optional "history" (keyValuePairs string) [ ( "tinder", "" ) ]
        |> required "settings" settingsDecoder
