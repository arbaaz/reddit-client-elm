module View.ActionBar exposing (actionBar)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Models exposing (Msg(..))


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
