module View.Post exposing (..)

-- import Debug exposing (..)
-- import Material.Elevation as Elevation
-- import Material

import Html exposing (..)
import Html.Attributes exposing (..)
import Material.Button as Button
import Material.Card as Card
import Material.Color as Color
import Material.Icon as Icon
import Material.Options as Options exposing (cs, css)
import Models exposing (Mdl, Post, PostHint(..), PostId, PostList, SubReddit)
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


isRichVideo : Post -> Bool
isRichVideo postHint =
    case postHint.postHint of
        RichVideo ->
            True

        _ ->
            False


redditPath : String -> String
redditPath pathName =
    "http://reddit.com/" ++ pathName


white : Options.Property c m
white =
    Color.text Color.white


renderPost : ( SubReddit, Post, Mdl ) -> Html Models.Msg
renderPost ( sub, post, mdl ) =
    let
        imageSrc =
            getPreview post.source

        background =
            "url(" ++ imageSrc ++ ") center / cover"

        media =
            if isRichVideo post then
                div [ style [ ( "position", "relative" ), ( "paddingBottom", "75%" ) ] ]
                    [ renderIframe (Maybe.withDefault "" post.mediaUrl) ]
            else
                a [ href post.imageUrl ]
                    [ img [ class "card-img-top", src imageSrc ] []
                    ]
    in
    if hasPreview post then
        Card.view
            [ css "width" "400px"
            , css "margin-bottom" "20px"
            , Color.background (Color.color Color.DeepPurple Color.S300)
            ]
            [ Card.title []
                [ Card.head [ white ] [ text post.title ]
                ]
            , Card.media
                [ css "background" "none"
                ]
                [ img [ class "card-img-top", src imageSrc ] [] ]
            , Card.menu []
                [ Button.render Mdl
                    [ 0, 0 ]
                    mdl
                    [ Button.icon, Button.ripple, white ]
                    [ Icon.i "share" ]
                ]
            , Card.actions
                [ Card.border, css "vertical-align" "center", css "text-align" "right", white ]
                [ Button.render Mdl
                    [ 8, 1 ]
                    mdl
                    [ Button.icon, Button.ripple ]
                    [ Icon.i "favorite_border" ]
                , Button.render Mdl
                    [ 8, 2 ]
                    mdl
                    [ Button.icon, Button.ripple ]
                    [ Icon.i "event_available" ]
                ]
            ]
    else
        div [] []


renderPosts : ( SubReddit, PostList, Mdl ) -> Html Models.Msg
renderPosts ( sub, posts, mdl ) =
    div [ class "postList" ] (List.map (\post -> renderPost ( sub, post, mdl )) posts)
