port module Main exposing (..)

import Decode exposing (dataDecoder, postDecoder, postsDecoder)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Models exposing (DataStore, Model, Post, PostList, Route(..), SubReddit)
import Navigation exposing (Location, modifyUrl)
import Routing exposing (parseLocation)
import View.Post exposing (renderPost)


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
            ( { model | loading = True }, Cmd.batch [ modifyUrl ("#r/" ++ model.query), toJs model.query ] )

        NextPosts ->
            ( { model | loading = True }, nextPosts model )

        PrevPosts ->
            ( { model | loading = True }, prevPosts model )

        RecordQuery query ->
            ( { model | query = query, after = "", before = "" }, Cmd.none )


renderPosts : ( SubReddit, PostList ) -> Html Msg
renderPosts ( sub, posts ) =
    div [ class "postList" ] (List.map (\post -> renderPost ( sub, post )) posts)


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
            page model


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
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
                [ div [ class "input-group" ]
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
                    sub ++ "/" ++ id

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
    }


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location

        model =
            initModel currentRoute
    in
    ( model, Cmd.batch [ fetchPosts model, toJs model.query ] )


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
