module View.ActionBar exposing (actionBar)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, onInput, onWithOptions)
import Json.Decode as JD
import Models exposing (Msg(ChangeSelection, FetchPosts, RecordQuery))


actionBar : Html Msg
actionBar =
    nav [ class "navbar navbar-dark fixed-bottom bg-dark p-1" ]
        [ Html.form [ class "form-inline" ]
            [ div [ class "form-row" ]
                [ div [ class "col-3" ]
                    [ select [ class "custom-select", onInput ChangeSelection ]
                        [ option [ selected True ] [ text "mode" ]
                        , option [ value "off" ] [ text "Off" ]
                        , option [ value "on" ] [ text "Image_View" ]
                        , option [ value "gif" ] [ text "Filter Gifs" ]
                        , option [ value "t10" ] [ text "Top 10" ]
                        , option [ value "t10gif" ] [ text "Top 10 Gifs" ]
                        , option [ value "10" ] [ text "10 results per page" ]
                        , option [ value "25" ] [ text "25 results per page" ]
                        , option [ value "100" ] [ text "100 results per page" ]
                        ]
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
