module Decode exposing (flagsDecoder, postDecoder, postsDecoder)

import Json.Decode as JD exposing (Decoder, andThen, bool, index, int, keyValuePairs, list, map2, string)
import Json.Decode.Pipeline exposing (decode, optional, required)
import Models exposing (Flags, Post, PostList, Response, SearchHistory, Settings)


postDecoder : Decoder Post
postDecoder =
    decode Post
        |> required "id" string
        |> optional "preview" string ""
        |> required "permalink" string
        |> required "title" string
        |> required "ups" int
        |> optional "post_hint" string "none"
        |> optional "preview" string ""
        |> optional "media_embed" string ""
        |> optional "url" string ""


postsDecoder : Decoder Response
postsDecoder =
    decode Response
        |> required "children" (JD.list postDecoder)
        |> optional "after" string ""
        |> optional "before" string ""
        |> optional "subreddit" string ""


settingsDecoder : Decoder Settings
settingsDecoder =
    decode Settings
        |> optional "count" string "10"
        |> optional "gifMode" bool False
        |> optional "imageMode" bool True
        |> optional "autoPlayGif" bool False
        |> optional "adultMode" bool False


arrayAsTuple2 : Decoder a -> Decoder b -> Decoder ( a, b )
arrayAsTuple2 a b =
    index 0 a
        |> andThen
            (\aVal ->
                index 1 b
                    |> andThen (\bVal -> JD.succeed ( aVal, bVal ))
            )



-- historyDecoder : Decoder SearchHistory
-- historyDecoder =
--     map2 (,) (index 0 string) (index 1 string)


flagsDecoder : Decoder Flags
flagsDecoder =
    decode Flags
        |> optional "history" (keyValuePairs string) [ ( "", "" ) ]
        |> required "settings" settingsDecoder
