module Api exposing (fetchPosts, nextPosts, prevPosts)

import Decode exposing (dataDecoder)
import Http
import Models exposing (DataStore, Model, Msg(..))


request : String -> Cmd Msg
request url =
    let
        req =
            Http.get url dataDecoder

        cmd =
            Http.send Posts req
    in
    cmd


fetchPosts : Model -> Cmd Msg
fetchPosts model =
    let
        url =
            "https://www.reddit.com/r/"
                ++ String.trim model.query
                ++ "/new.json?limit="
                ++ model.limit
                ++ "&count="
                ++ model.count
    in
    request url


nextPosts : Model -> Cmd Msg
nextPosts model =
    let
        url =
            "https://www.reddit.com/r/"
                ++ String.trim model.query
                ++ "/new.json?limit="
                ++ model.limit
                ++ "&count="
                ++ model.count
                ++ "&after="
                ++ model.after
    in
    request url


prevPosts : Model -> Cmd Msg
prevPosts model =
    let
        url =
            "https://www.reddit.com/r/"
                ++ String.trim model.query
                ++ "/new.json?limit="
                ++ model.limit
                ++ "&count="
                ++ model.count
                ++ "before="
                ++ model.before
    in
    request url
