module View.Iframe exposing (..)

import HtmlParser as HtmlParser exposing (parse)
import HtmlParser.Util exposing(toVirtualDom)
import Html exposing (Html, iframe, div)
-- import Html.Attributes exposing (attribute, src, style)


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

renderIframe srcUrl =
    toVirtualDom (parse srcUrl)
    
