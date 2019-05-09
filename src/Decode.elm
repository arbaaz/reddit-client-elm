module Decode exposing (..)

import Json.Decode.Pipeline exposing (decode, required, optional)
import Json.Decode as JD exposing (Decoder, int, string)
import Models exposing (Post, PostList)

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


postsDecoder : Decoder PostList
postsDecoder =
    (JD.at [ "children" ] (JD.list postDecoder))

