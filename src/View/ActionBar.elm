module View.ActionBar exposing (actionBar)

import Html exposing (Html, button, div, input, option, select, text)
import Html.Attributes exposing (class, value)
import Html.Events exposing (on, onClick, onInput)
import Models exposing (Msg(ChangeSelection, FetchPosts, NextPosts, PrevPosts, RecordQuery))


actionBar : Html Msg
actionBar =
    div [ class "container-fluid" ]
        [ div [ class "input-group" ]
            [ div [ class "input-group-prepend" ]
                [ -- button
                  -- [ onClick PrevPosts, class "btn btn-secondary" ]
                  -- [ text "Prev" ],
                  select [ onInput ChangeSelection ]
                    [ option [ value "off" ] [ text "mode" ]
                    , option [ value "off" ] [ text "Off" ]
                    , option [ value "on" ] [ text "On" ]
                    ]
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
        ]
