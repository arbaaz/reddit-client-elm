module Main exposing (main)

import Api exposing (fetchPosts)
import Debug exposing (log)
import Decode exposing (flagsDecoder)
import Dict exposing (Dict)
import Html exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Models exposing (Flags, Model, Msg(OnLocationChange), Route)
import Navigation exposing (Location)
import Routing exposing (parseLocation, routeParser, router)
import Update.Update exposing (update)


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


init : Decode.Value -> Location -> ( Model, Cmd Msg )
init initFlagsLocal location =
    let
        flags =
            case Decode.decodeValue flagsDecoder initFlagsLocal of
                Err _ ->
                    log "InitFlags decoding failed" initFlags

                Ok val ->
                    val

        currentRoute =
            Routing.parseLocation location

        model =
            initModel currentRoute flags
    in
    ( model, fetchPosts model )


main : Program Decode.Value Model Msg
main =
    Navigation.programWithFlags OnLocationChange
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
