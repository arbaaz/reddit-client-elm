module View.Page exposing (..)

-- import Material.Progress as Loading

import Html exposing (..)
import Html.Attributes exposing (..)
import Material.Spinner as Loading
import Models exposing (Mdl, Model, Msg)
import View.ActionBar exposing (actionBar)
import View.Post exposing (renderPosts)


page : Model -> Html Msg
page model =
    let
        posts =
            model.data

        query =
            model.query

        inner =
            div [ class "form" ]
                [ actionBar model
                , br [] []
                , renderPosts ( query, posts, model.mdl )
                ]
    in
    div [ id "outer" ]
        [ Loading.spinner
            [ Loading.active model.loading
            , Loading.singleColor True
            ]
        , inner
        , div [] [ text model.error ]
        ]
