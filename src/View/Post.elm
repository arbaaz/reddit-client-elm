module View.Post exposing (buildRoutePath, hasPreview, isGif, redditPath, renderMedia, renderPost, renderPosts, urlDecode)

import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (Mode, Post, PostHint(..), PostId, PostList, Settings, SubReddit)
import View.Iframe exposing (renderIframe)


urlDecode : String -> String
urlDecode =
    String.split "&amp;" >> String.join "&"


hasPreview : Post -> Bool
hasPreview post =
    if urlDecode post.source == "" then
        False

    else
        True


buildRoutePath : ( SubReddit, PostId ) -> String
buildRoutePath ( sub, id ) =
    "r/" ++ sub ++ "/" ++ id


isGif : Post -> Bool
isGif post =
    case post.postHint of
        Gif ->
            True

        _ ->
            False


redditPath : String -> String
redditPath pathName =
    "http://reddit.com/" ++ pathName


renderPost : ( SubReddit, Post, Settings ) -> Html msg
renderPost ( sub, post, settings ) =
    let
        post_path =
            buildRoutePath ( sub, post.id )

        image_view =
            renderMedia ( sub, post, settings )
    in
    if hasPreview post then
        if settings.imageMode then
            div [ class "row" ]
                [ div [ class "col col-xs-12" ]
                    [ div
                        [ class "card" ]
                        [ div [ class "post-hint" ]
                            [ text (Debug.toString post.postHint) ]
                        , image_view
                        ]
                    ]
                ]

        else
            div [ class "col col-xs-12" ]
                [ div
                    [ class "card" ]
                    [ a [ href ("#" ++ post_path) ]
                        [ text post.title ]
                    , div [ class "post-hint" ]
                        [ text (Debug.toString post.postHint) ]
                    , image_view
                    , a [ href (redditPath post.postUrl) ] [ text "open in reddit" ]
                    ]
                ]

    else
        div []
            [ a [ href post.url, target "_blank" ] [ text post.title ] ]


renderMedia : ( SubReddit, Post, Settings ) -> Html msg
renderMedia ( sub, post, settings ) =
    let
        post_path =
            buildRoutePath ( sub, post.id )

        ( thumbnail, original_content ) =
            let
                image_thumbnail =
                    img [ class "img-fluid card-img-top", src (urlDecode post.source) ] []

                render_iframe =
                    renderIframe post.iframe
            in
            if isGif post then
                if settings.autoPlayGif then
                    ( render_iframe, render_iframe )

                else
                    ( image_thumbnail, render_iframe )

            else
                ( image_thumbnail, image_thumbnail )

        anchor_attr =
            case post.postHint of
                Link ->
                    [ class "wiggle", href post.url, target "_blank" ]

                _ ->
                    [ class "wiggle", href ("#" ++ post_path) ]
    in
    div []
        [ a anchor_attr [ thumbnail ]
        , div [ class "lightbox short-animate", id post_path ] [ original_content ]
        , div [ id "lightbox-controls", class "short-animate" ] [ a [ id "close-lightbox", class "long-animate", href ("#r/" ++ sub) ] [] ]
        ]


renderPosts : ( SubReddit, PostList, Settings ) -> Html msg
renderPosts ( sub, posts, settings ) =
    let
        children =
            List.map (\post -> renderPost ( sub, post, settings )) posts
    in
    div [ class "container-fluid cards-container" ] children
