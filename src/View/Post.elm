module View.Post exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Models.Post exposing (Post)
import View.Iframe exposing (renderIframe)


hasPreview : Post -> String
hasPreview post =
    Maybe.withDefault "//place-hold.it/300x500" post.source


renderPost : Post -> Html msg
renderPost post =
    let
        media =
            if String.contains "gfycat" post.imageUrl then
                div [ style [ ( "position", "relative" ), ( "paddingBottom", "75%" ) ] ]
                    [ renderIframe post.imageUrl ]
            else
                img [ class "card-img-top", src (hasPreview post) ] []
    in
    div [ class "card" ]
        [ media
        , a [ href ("//www.reddit.com" ++ post.postUrl) ]
            [ text post.title ]
        ]
