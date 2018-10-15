port module Main exposing (..)

import Decode exposing (dataDecoder, postDecoder, postsDecoder)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Models exposing (DataStore, Model, Post, PostList, Route(..), SubReddit)
import Navigation exposing (Location, modifyUrl)
import Routing exposing (parseLocation)
import Set exposing (fromList, toList)
import View.Post exposing (renderPost, renderPosts)


port setStorage : List String -> Cmd msg


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

        request =
            Http.get url dataDecoder

        cmd =
            Http.send Posts request
    in
    cmd


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

        request =
            Http.get url dataDecoder

        cmd =
            Http.send Posts request
    in
    cmd


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

        request =
            Http.get url dataDecoder

        cmd =
            Http.send Posts request
    in
    cmd


type Msg
    = Posts (Result Http.Error DataStore)
    | FetchPosts
    | RecordQuery String
    | NextPosts
    | PrevPosts
    | OnLocationChange Location


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
                | data = List.reverse (List.sortBy .ups x.children)
                , after = Maybe.withDefault "" x.after
                , before = Maybe.withDefault "" x.before
                , loading = False
                , error = ""
              }
            , Cmd.none
            )

        Posts (Err err) ->
            ( { model | loading = False, error = toString err }, Cmd.none )

        FetchPosts ->
            let
                newModel =
                    { model | loading = True, history = toList <| fromList <| model.query :: model.history }
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


router : Model -> Html Msg
router model =
    case model.route of
        SubRedditRoute sub ->
            page model

        PostRoute sub id ->
            let
                postItem =
                    List.head (List.filter (\m -> m.id == id) model.data)
            in
            case postItem of
                Just post ->
                    renderPost ( sub, post )

                Nothing ->
                    notFoundView

        NotFoundRoute ->
            homePage model


renderLinks : String -> Html msg
renderLinks path =
    div []
        [ a [ class "links", href ("#r/" ++ path) ] [ text path ]
        , br [] []
        ]


homePage : Model -> Html Msg
homePage model =
    div []
        [ h3 []
            [ text "Interesting Subreddits" ]
        , div []
            (List.map
                renderLinks
                model.history
            )
        , actionBar
        ]


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]


actionBar : Html Msg
actionBar =
    div [ class "input-group" ]
        [ div [ class "input-group-prepend" ]
            [ button
                [ onClick PrevPosts, class "btn btn-secondary" ]
                [ text "Prev" ]
            ]
        , input [ onInput RecordQuery ] []
        , div [ class "input-group-append" ]
            [ button
                [ onClick FetchPosts
                , class "btn btn-success"
                ]
                [ text "Fetch" ]
            , button
                [ onClick NextPosts, class "btn btn-primary" ]
                [ text "Next" ]
            ]
        ]


page : Model -> Html Msg
page model =
    let
        posts =
            model.data

        query =
            model.query

        inner =
            div [ class "form" ]
                [ actionBar
                , br [] []
                , renderPosts ( query, posts )
                ]
    in
    div [ id "outer" ]
        [ if model.loading then
            div [ class "loader" ] []
          else
            inner
        , div [] [ text model.error ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


routeParser : Route -> String
routeParser route =
    let
        query =
            case route of
                PostRoute sub id ->
                    sub

                SubRedditRoute sub ->
                    sub

                NotFoundRoute ->
                    "tinder"
    in
    query


initModel : Route -> Model
initModel route =
    let
        query =
            routeParser route
    in
    { data = []
    , query = query
    , error = ""
    , after = ""
    , before = ""
    , loading = False
    , limit = "25"
    , count = "0"
    , route = route
    , history = []
    }


type alias Flags =
    String


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
