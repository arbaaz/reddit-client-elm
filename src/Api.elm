module Api exposing (fetchPosts, nextPosts, prevPosts)

import Decode exposing (postsDecoder)
import Http
import Models exposing (Model, Msg(..))


host : String
host =
    "https://redditcr.herokuapp.com"



-- host ="http://localhost:6001"
-- host =
--     "http://192.168.0.107:6001"


request : String -> Cmd Msg
request url =
    Http.send Posts
        (Http.request
            { method = "GET"
            , headers = []
            , url = url
            , body = Http.emptyBody
            , expect = Http.expectJson postsDecoder
            , timeout = Nothing
            , withCredentials = False
            }
        )


fetchPosts : Model -> Cmd Msg
fetchPosts model =
    let
        url =
            host ++ "/reddit?query=" ++ String.trim model.query
    in
    request url


nextPosts : Model -> Cmd Msg
nextPosts model =
    let
        url =
            host
                ++ "/reddit?query="
                ++ String.trim model.query
                ++ "&after="
                ++ model.after
    in
    request url


prevPosts : Model -> Cmd Msg
prevPosts model =
    let
        url =
            host
                ++ "/reddit?query="
                ++ String.trim model.query
                ++ "&before="
                ++ model.before
    in
    request url
