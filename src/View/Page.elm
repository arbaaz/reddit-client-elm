module View.Page exposing (page)

import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (Model, Msg)
import View.ActionBar exposing (actionBar)
import View.Post exposing (renderPosts)


page : Model -> Html Msg
page model =
    let
        posts =
            model.children

        query =
            model.query

        mode =
            model.mode

        inner =
            div [ class "form" ]
                [ actionBar
                , br [] []
                , div [] [ text query ]
                , renderPosts ( query, posts, mode )
                ]
    in
    div [ id "outer" ]
        [ if model.loading then
            div [ class "loader" ] []

          else
            inner
        , div [] [ text model.error ]
        ]
