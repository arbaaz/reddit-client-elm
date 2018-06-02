module View.Iframe exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


renderIframe : String -> Html msg
renderIframe srcUrl =
    iframe
        [ src srcUrl
        , attribute "frameborder" "0"
        , attribute "width" "100%"
        , attribute "height" "100%"
        , attribute "scrolling" "no"
        , attribute "allowfullscreen" "true"
        , style [ ( "position", "absolute" ), ( "top", "0" ), ( "left", "0" ) ]
        ]
        []
