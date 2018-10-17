module View.ActionBar exposing (actionBar)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Material.Button as Button
import Material.Options as Options
import Models exposing (Msg(..))


actionBar : Models.Model -> Html Msg
actionBar model =
    div [ class "input-group" ]
        [ div [ class "input-group-prepend" ]
            [ Button.render
                Mdl
                [ 0 ]
                model.mdl
                [ Button.raised
                , Button.colored
                , Options.onClick PrevPosts
                ]
                [ text "Prev" ]
            ]
        , input [ onInput RecordQuery ] []
        , div [ class "input-group-append" ]
            [ Button.render
                Mdl
                [ 0 ]
                model.mdl
                [ Button.raised
                , Button.colored
                , Options.onClick FetchPosts
                ]
                [ text "Fetch" ]
            , Button.render
                Mdl
                [ 0 ]
                model.mdl
                [ Button.raised
                , Button.colored
                , Options.onClick NextPosts
                ]
                [ text "Next" ]
            ]
        ]
