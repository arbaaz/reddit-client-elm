module View.ActionBar exposing (actionBar)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, onInput, onWithOptions)
import Json.Decode as JD
import Models exposing (Msg(FetchPosts, FetchRandNsfw, RecordQuery))


config : { preventDefault : Bool, stopPropagation : Bool }
config =
    { stopPropagation = True, preventDefault = True }


actionBar : Html Msg
actionBar =
    nav [ class "navbar navbar-dark fixed-bottom bg-dark p-1" ]
        [ Html.form [ class "form-inline" ]
            [ 
                button [ onWithOptions "click" config (JD.succeed FetchRandNsfw), class "btn btn-outline-success mr-2" ] [ text "Randnsfw" ]
                , input [ class "mr-2", type_ "search", placeholder "Search", onInput RecordQuery ][]
                , button [ onWithOptions "click" config (JD.succeed FetchPosts), class "btn btn-outline-success" ] [ text "Search" ]
                
            ]
        ]