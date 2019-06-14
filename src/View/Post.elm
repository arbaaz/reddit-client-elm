module View.Post exposing (hasPreview, isGif, postPath, redditPath, renderPost, renderPosts, split, urlDecode)

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


postPath : ( SubReddit, PostId ) -> String
postPath ( sub, id ) =
    "r/" ++ sub ++ "/" ++ id


isGif : Post -> Bool
isGif post =
    case post.postHint of
        "rich:video" ->
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
            postPath ( sub, post.id )

        lightbox_path = case post.postHint of
            "link" ->
                post.url
            _ ->
            "#" ++ post_path
        image_thumbnail =
            div []
                [ a [ href (lightbox_path), class "wiggle", target "_blank" ]
                    [ img [ class "img-fluid card-img-top", src (urlDecode post.source) ] []
                    ]
                , div [ class "lightbox short-animate", id post_path ] [ img [ class "long-animate", src (post.url) ] [] ]
                , div [ id "lightbox-controls", class "short-animate" ] [ a [ id "close-lightbox", class "long-animate", href ("#r/" ++ sub) ] [] ]
                ]

        
        image_view =
            let mediaObject =  if settings.gifMode then
                renderIframe post.mediaUrl
            else
                img [ class "img-fluid card-img-top", src (urlDecode post.source) ] []
            in
                if isGif post then
                div [][
                    a [ href (lightbox_path), class "wiggle" ]
                    [ mediaObject]
                , div [ class "lightbox short-animate", id post_path ] [ renderIframe post.mediaUrl]
                , div [ id "lightbox-controls", class "short-animate" ] [ a [ id "close-lightbox", class "long-animate", href ("#r/" ++ sub) ] [] ]
                ]

                else
                    image_thumbnail

    in
    if hasPreview post then
        if settings.imageMode then
            div [ class "row" ]
                [ div [ class "col col-xs-12" ]
                    [ div
                        [ class "card" ]
                        [ div [ class "post-hint" ]
                            [ text (toString post.postHint) ]
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
                        [ text (toString post.postHint) ]
                    , image_view
                    , a [ href (redditPath post.postUrl) ] [ text "open in reddit" ]
                    ]
                ]

    else
        div [] []


split : Int -> List a -> List (List a)
split i list =
    case List.take i list of
        [] ->
            []

        listHead ->
            listHead :: split i (List.drop i list)


renderPosts : ( SubReddit, PostList, Settings ) -> Html msg
renderPosts ( sub, posts, settings ) =
    div [ class "container-fluid cards-container" ]
        (List.map (\post -> renderPost ( sub, post, settings )) posts)
