module View.Page exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (Model, Msg)
import View.ActionBar exposing (actionBar)
import View.Post exposing (renderGallery, renderPosts)


page : Model -> Html Msg
page model =
    let
        posts =
            model.data

        query =
            model.query

        inner =
            div [ class "form" ]
                [ actionBar
                , br [] []
                , renderGallery ( query, posts )
                ]
    in
    div [ id "outer" ]
        [ if model.loading then
            div [ class "loader" ] []
          else
            inner
        , div [] [ text model.error ]
        ]
