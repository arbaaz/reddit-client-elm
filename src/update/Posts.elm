module Update.Posts exposing (fetchPost, postFail, postSuccess)

import Api exposing (fetchPosts)
import Dict exposing (Dict)
import Http
import Models exposing (Model, Msg, Response)
import Navigation exposing (modifyUrl)
import Update.Port exposing (setStorage, toGoogleAnalytics)


fetchPost : Model -> ( Model, Cmd Msg )
fetchPost model =
    let
        newModel =
            { model | loading = True }
    in
    ( newModel, Cmd.batch [ fetchPosts newModel, toGoogleAnalytics model.query ] )


postSuccess : Response -> Model -> ( Model, Cmd Msg )
postSuccess response model =
    let
        newModel =
            { model
                | children = response.children
                , history = Dict.insert response.subreddit response.after model.history
                , query = response.subreddit
                , before = response.before
                , loading = False
                , error = ""
            }
    in
    ( newModel, Cmd.batch [ modifyUrl ("#r/" ++ response.subreddit), setStorage { history = Dict.toList newModel.history, settings = newModel.settings } ] )


postFail : Http.Error -> Model -> ( Model, Cmd Msg )
postFail err model =
    case err of
        Http.BadStatus status ->
            ( { model | loading = False, error = toString status.status.message }, Cmd.none )

        _ ->
            ( { model | loading = False, error = "Something went wrong" }, Cmd.none )
