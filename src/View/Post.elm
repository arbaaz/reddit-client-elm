module View.Post exposing (..)

-- import Debug exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (Post, PostId, SubReddit)
import View.Iframe exposing (renderIframe)


urlDecode : String -> String
urlDecode =
    String.split "&amp;" >> String.join "&"


getPreview : Maybe String -> String
getPreview =
    Maybe.withDefault "" >> urlDecode


hasPreview : Post -> Bool
hasPreview post =
    if getPreview post.source == "" then
        False
    else
        True


postPath : ( SubReddit, PostId ) -> String
postPath ( sub, id ) =
    "#r/" ++ sub ++ "/" ++ id


renderPost : ( SubReddit, Post ) -> Html msg
renderPost ( sub, post ) =
    let
        media =
            if post.postHint == Just "rich:video" then
                div [ style [ ( "position", "relative" ), ( "paddingBottom", "75%" ) ] ]
                    [ renderIframe (Maybe.withDefault "" post.mediaUrl) ]
            else
                img [ class "card-img-top", src (getPreview post.source) ] []
    in
    if hasPreview post then
        div
            [ class "card" ]
            [ media
            , a [ href (postPath ( sub, post.id )) ]
                [ text post.title ]
            ]
    else
        div [] []
