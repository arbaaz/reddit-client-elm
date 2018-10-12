port module Main exposing (..)

-- import Debug exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as JD exposing (Decoder, at, field, int, list, map3, string)
import Models.Post exposing (Post)
import View.Post exposing (renderPost)


type alias PostList =
    List Post


type alias DataStore =
    { after : Maybe String
    , before : Maybe String
    , children : PostList
    }


postDecoder : Decoder Post
postDecoder =
    JD.map5 Post
        (field "url" string)
        (field "permalink" string)
        (field "title" string)
        (field "ups" int)
        (JD.maybe (field "url" string))


postsDecoder : Decoder PostList
postsDecoder =
    at [ "data" ] postDecoder
        |> JD.list


dataDecoder : Decoder DataStore
dataDecoder =
    at [ "data" ] <|
        JD.map3 DataStore
            (JD.maybe (field "after" string))
            (JD.maybe (field "before" string))
            (field "children" postsDecoder)


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


port toJs : String -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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
            ( { model | loading = True }, Cmd.batch [ fetchPosts model, toJs model.query ] )

        NextPosts ->
            ( { model | loading = True }, nextPosts model )

        PrevPosts ->
            ( { model | loading = True }, prevPosts model )

        RecordQuery query ->
            ( { model | query = query, after = "", before = "" }, Cmd.none )


renderPosts : Model -> Html Msg
renderPosts posts =
    div [ class "postList" ] (List.map renderPost posts.data)


view : Model -> Html Msg
view model =
    let
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
                , renderPosts model
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


type alias Model =
    { data : PostList
    , query : String
    , error : String
    , after : String
    , before : String
    , loading : Bool
    , limit : String
    , count : String
    }


initModel : Model
initModel =
    { data = []
    , query = "tinder"
    , error = ""
    , after = ""
    , before = ""
    , loading = False
    , limit = "25"
    , count = "0"
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, fetchPosts initModel )


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
