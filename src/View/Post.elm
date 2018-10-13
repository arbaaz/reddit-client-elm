module View.Post exposing (..)

-- import Debug exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (Post, PostId)
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


postPath : PostId -> String
postPath id =
    "#post/" ++ id


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
            , a [ href (postPath post.id) ]
                [ text post.title ]
            ]
    else
        div [] []
