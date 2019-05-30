module View.Page exposing (page)

import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (Model, Msg)
import View.ActionBar exposing (actionBar)
import View.Post exposing (isGif, renderPosts)


page : Model -> Html Msg
page model =
    let
        posts =
            filterData ( model.settings, model.children )

        query =
            model.query

        gifMode =
            model.settings.gifMode

        inner =
            div [ class "form" ]
                [ actionBar
                , nav [ class "navbar navbar-dark bg-dark" ]
                    [ a [ class "navbar-brand", href "#home" ]
                        [ text "Home"
                        ]
                    , ul [ class "navbar-nav mr-auto" ]
                        [ li [ class "nav-item" ] [ a [ href "#preferences", class "nav-link" ] [ text "settings" ] ]
                        ]
                    , div
                        []
                        [ text query ]
                    ]
                , renderPosts ( query, posts, gifMode )
                ]
    in
    div
        [ id "outer" ]
        [ if model.loading then
            div [ class "loader" ] []

          else
            inner
        , div [] [ text model.error ]
        ]


filterData : ( Models.Settings, List Models.Post ) -> List Models.Post
filterData ( settings, children ) =
    if settings.gifMode then
        List.filter isGif children

    else
        children
