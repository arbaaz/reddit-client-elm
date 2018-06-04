module View.Post exposing (..)

-- import Debug exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Models.Post exposing (Post)
import View.Iframe exposing (renderIframe)


getPreview : Post -> String
getPreview post =
    Maybe.withDefault "" post.source


hasPreview : Post -> Bool
hasPreview post =
    if getPreview post == "" then
        False
    else
        True


renderPost : Post -> Html msg
renderPost post =
    let
        media =
            if String.contains "gfycat" post.imageUrl then
                div [ style [ ( "position", "relative" ), ( "paddingBottom", "75%" ) ] ]
                    [ renderIframe post.imageUrl ]
            else
                img [ class "card-img-top", src (getPreview post) ] []
    in
    if hasPreview post then
        div
            [ class "card" ]
            [ media
            , a [ href ("//www.reddit.com" ++ post.postUrl) ]
                [ text post.title ]
            ]
    else
        div [] []
