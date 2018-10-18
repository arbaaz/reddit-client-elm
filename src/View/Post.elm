module View.Post exposing (..)

-- import Debug exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (Post, PostHint(..), PostId, PostList, SubReddit)
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


renderPost : ( SubReddit, Post ) -> Html msg
renderPost ( sub, post ) =
    let
        media =
            if isRichVideo post then
                div [ style [ ( "position", "relative" ), ( "paddingBottom", "75%" ) ] ]
                    [ renderIframe (Maybe.withDefault "" post.mediaUrl) ]
            else if post.source == Just "" then
                img [ class "card-img-top", src (getPreview post.source) ] []
            else
                a [ href post.imageUrl ]
                    [ img [ class "img-fluid card-img-top", src (getPreview post.source) ] []
                    ]
    in
    if hasPreview post then
        div [ class "col col-xs-12" ]
            [ div
                [ class "card" ]
                [ media
                , a [ href (postPath ( sub, post.id )) ]
                    [ text post.title ]
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


renderPosts : ( SubReddit, PostList ) -> Html msg
renderPosts ( sub, posts ) =
    let
        data =
            split 4 posts
    in
    div [ class "container-fluid " ]
        (List.map
            (\posts ->
                div [ class "row" ] (List.map (\post -> renderPost ( sub, post )) posts)
            )
            data
        )


renderGallery : ( SubReddit, PostList ) -> Html msg
renderGallery ( sub, posts ) =
    let
        imgList =
            List.map .source posts |> List.map getPreview
    in
    div [ class "gallery" ] (List.map (\url -> div [ class "img" ] [ img [ src url ] [] ]) imgList)
