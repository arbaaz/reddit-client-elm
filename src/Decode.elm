module Decode exposing (..)

import Json.Decode.Pipeline exposing (decode, required, optional)
import Json.Decode as JD exposing (Decoder, int, string)
import Models exposing (Post, PostList, Response)

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


postsDecoder : Decoder Response
postsDecoder =
    decode Response
    |> required "children" (JD.list postDecoder)
    |> optional "after"  string ""
    |> optional "before" string ""
    

