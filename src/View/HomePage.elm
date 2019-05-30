module View.HomePage exposing (homePage)

import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Models exposing (Model, Msg(..))
import View.ActionBar exposing (actionBar)


homePage : Model -> Html Msg
homePage model =
    div []
        [ h3 []
            [ text "Interesting Subreddits" ]
        , ul [ class "list-group list-group-flush" ]
            (List.map renderLinks (Dict.keys model.history))
        , actionBar
        ]


renderLinks : String -> Html Msg
renderLinks path =
    li [ class "list-group-item list-group-item-action list-group-item-dark" ]
        [ a [ class "links", href ("#r/" ++ path) ] [ text path ]
        , button [ onClick (DeleteHistory path) ] [ text "x" ]
        ]
