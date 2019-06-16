module View.Page exposing (page)

import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (Model, Msg)
import View.ActionBar exposing (actionBar)
import View.Loader exposing (loader)
import View.Post exposing (isGif, renderPosts)


page : Model -> Html Msg
page model =
    let
        posts =
            filterData ( model.settings, model.children )

        query =
            model.query

        inner =
            div [ class "form" ]
                [ nav [ class "navbar navbar-dark bg-dark fixed-top" ]
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
                , renderPosts ( query, posts, model.settings )
                , actionBar
                ]
    in
    div
        [ id "outer" ]
        [ if model.loading then
            loader

          else
            inner
        , div [] [ text model.error ]
        ]



-- renderLightBox =


filterData : ( Models.Settings, List Models.Post ) -> List Models.Post
filterData ( settings, children ) =
    if settings.gifMode then
        List.filter isGif children

    else
        children
