module View.Loader exposing (loader)

import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (Msg)


loader : Html Msg
loader =
    div [ class "loader-container" ]
        [ div [ class "loader" ] []
        ]
