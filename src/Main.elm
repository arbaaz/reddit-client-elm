port module Main exposing (..)

import Api exposing (fetchPosts, nextPosts, prevPosts)
import Html exposing (..)
import Models exposing (Flags, Model, Msg(..), Route, SearchHistory)
import Navigation exposing (Location, modifyUrl)
import Routing exposing (parseLocation, routeParser, router)
import Set exposing (fromList, toList)


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
                | 
                children = x.children
                --  List.reverse (List.sortBy .ups x.children)
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
