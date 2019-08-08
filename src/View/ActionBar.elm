module View.ActionBar exposing (actionBar)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, onInput)
import Json.Decode as JD
import Models exposing (Msg(..))


config : { preventDefault : Bool, stopPropagation : Bool }
config =
    { stopPropagation = True, preventDefault = True }


actionBar : Html Msg
actionBar =
    nav [ class "navbar navbar-dark fixed-bottom bg-dark p-1" ]
        [ Html.form [ class "form-inline" ]
            [ button [ Html.Events.custom "click" (JD.succeed { message = FetchRandNsfw, stopPropagation = True, preventDefault = True }), class "btn btn-outline-success mr-2" ] [ text "Randnsfw" ]
            , input [ class "mr-2", type_ "search", placeholder "Search", onInput RecordQuery ] []
            , button [ Html.Events.custom "click" (JD.succeed { message = FetchPosts, stopPropagation = True, preventDefault = True }), class "btn btn-outline-success" ] [ text "Search" ]
            ]
        ]
