module View.ActionBar exposing (actionBar)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, onInput, onWithOptions)
import Json.Decode as JD
import Models exposing (Msg(FetchPosts, FetchRandNsfw, RecordQuery))


actionBar : Html Msg
actionBar =
    nav [ class "navbar navbar-dark fixed-bottom bg-dark p-1" ]
        [ Html.form [ class "form-inline" ]
            [ div [ class "form-row" ]
                [ div [ class "col-3" ]
                    [ button [ onWithOptions "click" { stopPropagation = True, preventDefault = True } (JD.succeed FetchRandNsfw), class "btn btn-outline-success" ] [ text "Randnsfw" ]
                    ]
                , div [ class "col-5" ]
                    [ input [ class "form-control", type_ "search", placeholder "Search", onInput RecordQuery ]
                        []
                    ]
                , div [ class "col-4" ]
                    [ button [ onWithOptions "click" { stopPropagation = True, preventDefault = True } (JD.succeed FetchPosts), class "btn btn-outline-success" ] [ text "Search" ]
                    ]
                ]
            ]
        ]
