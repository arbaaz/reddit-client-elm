module Api exposing (fetchPosts)

import Decode exposing (postsDecoder)
import Dict exposing (Dict)
import Http
import Models exposing (Model, Msg(..))


host : String
host =
    "https://redditcr.herokuapp.com"



-- host =
--     "http://localhost:6001"
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


buildUrl : Model -> String
buildUrl model =
    let
        url =
            host ++ "/reddit?query=" ++ String.trim model.query ++ "&count=" ++ model.settings.count
    in
    case Dict.get model.query model.history of
        Just value ->
            url ++ "&after=" ++ value

        Nothing ->
            url


fetchPosts : Model -> Cmd Msg
fetchPosts model =
    let
        url =
            buildUrl model
    in
    request url
