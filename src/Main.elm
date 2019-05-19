port module Main exposing (init, initModel, main, setStorage, subscriptions, toJs, update, view)

import Api exposing (fetchPosts, nextPosts, prevPosts)
import Html exposing (..)
import Models exposing (Flags, Model, Msg(..), Route, SearchHistory)
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
                    parseLocation location

                query =
                    routeParser newRoute

                newModel =
                    { model | route = newRoute, query = query }
            in
            ( newModel, fetchPosts newModel )

        Posts (Ok x) ->
            ( { model
                | children = filterData ( model.mode, x.children )
                , after = x.after
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
            ( newModel, Cmd.batch [ modifyUrl ("#r/" ++ model.query), toJs model.query, setStorage newModel.history ] )

        NextPosts ->
            ( { model | loading = True }, nextPosts model )

        PrevPosts ->
            ( { model | loading = True }, prevPosts model )

        RecordQuery query ->
            ( { model | query = query, after = "", before = "" }, Cmd.none )

        ChangeSelection value ->
            ( { model | children = filterData ( value, model.children ), mode = value }, Cmd.none )


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
    , after = ""
    , before = ""
    , loading = False
    , limit = "26"
    , count = "0"
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
