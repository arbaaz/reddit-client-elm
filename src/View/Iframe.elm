module View.Iframe exposing (renderIframe)

-- import Html.Attributes exposing (attribute, src, style)

import Html exposing (Html, div, iframe)
import HtmlParser as HtmlParser exposing (Node(Text), parse)
import HtmlParser.Util exposing (toVirtualDom)



-- renderIframe : String -> Html msg
-- renderIframe srcUrl =
--     iframe
--         [ src srcUrl
--         , attribute "frameborder" "0"
--         , attribute "width" "100%"
--         , attribute "height" "100%"
--         , attribute "scrolling" "no"
--         , attribute "allowfullscreen" "true"
--         , style [ ( "position", "absolute" ), ( "top", "0" ), ( "left", "0" ) ]
--         ]
--         []


renderIframe : String -> Html msg
renderIframe srcUrl =
    let
        nodes =
            toVirtualDom (parse srcUrl)
    in
    case List.head nodes of
        Nothing ->
            div [] []

        Just val ->
            val
