module View.Post exposing (getPreview, hasPreview, isGif, postPath, redditPath, renderPost, renderPosts, split, urlDecode)

import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (Mode, Post, PostHint(..), PostId, PostList, SubReddit)
import View.Iframe exposing (renderIframe)


urlDecode : String -> String
urlDecode =
    String.split "&amp;" >> String.join "&"


getPreview : String -> String
getPreview =
    urlDecode


hasPreview : Post -> Bool
hasPreview post =
    if getPreview post.source == "" then
        False

    else
        True


postPath : ( SubReddit, PostId ) -> String
postPath ( sub, id ) =
    "#r/" ++ sub ++ "/" ++ id


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


renderPost : ( SubReddit, Post, Bool ) -> Html msg
renderPost ( sub, post, gifMode ) =
    let
        post_path =
            postPath ( sub, post.id )

        image_thumbnail =
            div []
                [ a [ href ("#lb/" ++ post.id), class "wiggle" ]
                    [ img [ class "img-fluid card-img-top", src (getPreview post.source) ] []
                    ]
                , div [ class "lightbox short-animate", id ("lb/" ++ post.id) ] [ img [ class "long-animate", src (getPreview post.source) ] [] ]
                , div [ id "lightbox-controls", class "short-animate" ] [ a [ id "close-lightbox", class "long-animate", href ("#r/" ++ sub) ] [] ]
                ]

        image_view =
            if gifMode then
                if isGif post then
                    div [ style [ ( "position", "relative" ), ( "paddingBottom", "75%" ) ] ] [ renderIframe post.mediaUrl ]

                else
                    image_thumbnail

            else
                image_thumbnail
    in
    if hasPreview post then
        if not gifMode then
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
                    [ a [ href (postPath ( sub, post.id )) ]
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


renderPosts : ( SubReddit, PostList, Bool ) -> Html msg
renderPosts ( sub, posts, gifMode ) =
    div [ class "cards-container" ]
        (List.map (\post -> renderPost ( sub, post, gifMode )) posts)
