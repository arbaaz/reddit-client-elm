module Main exposing (main)

import Api exposing (fetchPosts)
import Browser
import Browser.Navigation as Nav
import Debug
import Decode exposing (flagsDecoder)
import Dict exposing (Dict)
import Html exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Models exposing (Flags, Model, Msg(..), Route(..))
import Routing exposing (routeParser, router)
import Update.Update exposing (update)
import Url


view : Model -> Browser.Document Msg
view model =
    { title = "Reddit"
    , body =
        [ div []
            [ router model ]
        ]
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


initModel : Url.Url -> Nav.Key -> Route -> Flags -> Model
initModel url key route flags =
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
    , key = key
    , url = url
    }


initFlags : Flags
initFlags =
    { history = [ ( "tinder", "" ) ]
    , settings =
        { count = "10"
        , gifMode = False
        , imageMode = True
        , autoPlayGif = False
        , adultMode = False
        }
    }


init : Decode.Value -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init initFlagsLocal url key =
    let
        flags =
            case Decode.decodeValue flagsDecoder initFlagsLocal of
                Err _ ->
                    initFlags

                Ok val ->
                    val

        model =
            initModel url key Home flags
    in
    ( model, Cmd.none )



-- init initFlagsLocal location =
--     let
--         flags =
--             case Decode.decodeValue flagsDecoder initFlagsLocal of
--                 Err _ ->
--                     initFlags
--                 Ok val ->
--                     val
--         currentRoute =
--             Routing.parseLocation location
--         model =
--             initModel currentRoute flags
--     in
--     case currentRoute of
--         PostRoute sub id ->
--             ( model, fetchPosts model )
--         SubRedditRoute sub ->
--             ( model, fetchPosts model )
--         _ ->
--             ( model, Cmd.none )


main : Program Decode.Value Model Msg
main =
    Browser.application
        { init = init
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
