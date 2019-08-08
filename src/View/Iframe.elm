module View.Iframe exposing (renderIframe)

-- import HtmlParser.Util exposing (getValue, toVirtualDom)
-- import HtmlParser as HtmlParser exposing (Node(..), parse)

import Debug exposing (log)
import Html exposing (Html, div, iframe)
import Html.Attributes exposing (attribute, class, src, style)
import Json.Decode


renderIframe : String -> Html msg
renderIframe srcUrl =
    let
        url =
            srcUrl
    in
    iframe
        [ src url
        , class "gif"
        , attribute "frameborder" "0"
        , attribute "width" "100%"
        , attribute "height" "100%"
        , attribute "scrolling" "no"
        , attribute "allowfullscreen" "true"

        -- , style [ ( "position", "absolute" ), ( "top", "0" ), ( "left", "0" ) ]
        ]
        []



-- extractUrl : String -> String
-- extractUrl srcUrl =
--     let
--         f node init =
--             case node of
--                 Element tagName attrs children ->
--                     case getValue "src" attrs of
--                         Just val ->
--                             val
--                         Nothing ->
--                             ""
--                 _ ->
--                     init
--     in
--     List.foldl f "" (parse srcUrl)
