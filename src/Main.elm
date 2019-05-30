port module Main exposing (init, initModel, main, setStorage, subscriptions, toGoogleAnalytics, update, view)

import Api exposing (fetchPosts)
import Debug exposing (log)
import Dict exposing (Dict)
import Html exposing (..)
import Http
import Models exposing (Flags, Model, Msg(..), Route(..))
import Navigation exposing (Location, modifyUrl)
import Routing exposing (parseLocation, routeParser, router)
import View.Post exposing (isGif)


port setStorage : List ( String, String ) -> Cmd msg


port toGoogleAnalytics : String -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnLocationChange location ->
            let
                newRoute =
                    log "newRoute" (parseLocation location)

                query =
                    routeParser newRoute
            in
            case ( model.route, newRoute ) of
                ( Home, SubRedditRoute sub ) ->
                    let
                        newModel =
                            { model | route = newRoute, query = query }
                    in
                    ( newModel, fetchPosts newModel )

                _ ->
                    ( { model | route = newRoute }, Cmd.none )

        Posts (Ok x) ->
            let
                newModel =
                    { model
                        | children = filterData ( model.mode, x.children )
                        , history = Dict.insert x.subreddit x.after model.history
                        , query = x.subreddit
                        , before = x.before
                        , loading = False
                        , error = ""
                    }
            in
            ( newModel, Cmd.batch [ modifyUrl ("#r/" ++ x.subreddit), setStorage (Dict.toList newModel.history) ] )

        Posts (Err err) ->
            case err of
                Http.BadStatus status ->
                    ( { model | loading = False, error = toString status.status.message }, Cmd.none )

                _ ->
                    ( { model | loading = False, error = "Something went wrong" }, Cmd.none )

        FetchPosts ->
            let
                newModel =
                    { model | loading = True }
            in
            ( newModel, Cmd.batch [ fetchPosts newModel, toGoogleAnalytics model.query ] )

        -- ( newModel, Cmd.none )
        RecordQuery query ->
            ( { model | query = query }, Cmd.none )

        FetchRandNsfw ->
            let
                newModel =
                    { model | query = "randnsfw", loading = True }
            in
            ( newModel, fetchPosts newModel )

        DeleteHistory sub ->
            let
                history =
                    Dict.remove sub model.history
            in
            ( { model | history = history }, setStorage (Dict.toList history) )

        ChangeSelection value ->
            let
                count =
                    if value == "10" then
                        value

                    else if value == "100" then
                        value

                    else if value == "25" then
                        value

                    else
                        model.count
            in
            ( { model | children = filterData ( value, model.children ), mode = value, count = count }, Cmd.none )


filterData : ( String, List Models.Post ) -> List Models.Post
filterData ( mode, children ) =
    if mode == "gif" then
        List.filter isGif children

    else if mode == "t10" then
        List.take 10 children

    else if mode == "t10gif" then
        List.take 10 (List.filter isGif children)

    else
        children


view : Model -> Html Msg
view model =
    div []
        [ router model ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


initModel : Route -> Flags -> Model
initModel route flags =
    { children = []
    , query = routeParser route
    , error = ""
    , before = ""
    , loading = False
    , limit = "10"
    , count = "10"
    , route = route
    , history = Dict.fromList flags.history
    , mode = "on"
    , settings = flags.settings
    }


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        currentRoute =
            Routing.parseLocation location

        model =
            initModel currentRoute flags
    in
    ( model, Cmd.none )


main : Program Flags Model Msg
main =
    Navigation.programWithFlags OnLocationChange
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
