port module Main exposing (init, initModel, main, setStorage, subscriptions, toJs, update, view)

import Api exposing (fetchPosts)
import Debug exposing (log)
import Dict exposing (Dict)
import Html exposing (..)
import Models exposing (Flags, Model, Msg(..), Route(..), SearchHistory)
import Navigation exposing (Location, modifyUrl)
import Routing exposing (parseLocation, routeParser, router)
import Set exposing (fromList, toList)
import View.Post exposing (isGif)


port setStorage : SearchHistory -> Cmd msg


port toJs : String -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnLocationChange location ->
            let
                newRoute =
                    log "newRoute" (parseLocation location)

                query =
                    routeParser newRoute

                newModel =
                    { model | route = newRoute, query = query }

                cmd =
                    case newRoute of
                        PostRoute sub id ->
                            Cmd.none

                        SubRedditRoute sub ->
                            fetchPosts newModel

                        NotFoundRoute ->
                            Cmd.none
            in
            ( newModel, cmd )

        Posts (Ok x) ->
            ( { model
                | children = filterData ( model.mode, x.children )
                , after = Dict.insert model.query x.after model.after
                , before = x.before
                , loading = False
                , error = ""
              }
            , Cmd.none
            )

        Posts (Err err) ->
            ( { model | loading = False, error = toString err }, Cmd.none )

        FetchPosts ->
            let
                history_ =
                    toList <| fromList <| model.query :: model.history

                newModel =
                    { model | loading = True, history = history_ }
            in
            ( newModel, Cmd.batch [ fetchPosts newModel, toJs model.query, setStorage newModel.history ] )

        -- ( newModel, Cmd.none )
        RecordQuery query ->
            ( { model | query = query }, Cmd.none )

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


initModel : Route -> Model
initModel route =
    { children = []
    , query = routeParser route
    , error = ""
    , after = Dict.empty
    , before = ""
    , loading = False
    , limit = "10"
    , count = "10"
    , route = route
    , history = []
    , mode = "on"
    }


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        currentRoute =
            Routing.parseLocation location

        model =
            initModel currentRoute
    in
    ( { model | history = String.split "_" flags }, Cmd.batch [ fetchPosts model, toJs model.query ] )


main : Program Flags Model Msg
main =
    Navigation.programWithFlags OnLocationChange
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
