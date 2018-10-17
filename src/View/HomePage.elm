module View.HomePage exposing (homePage)

import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (Model, Msg)
import View.ActionBar exposing (actionBar)


homePage : Model -> Html Msg
homePage model =
    div []
        [ h3 []
            [ text "Interesting Subreddits" ]
        , div []
            (List.map
                renderLinks
                model.history
            )
        , actionBar model
        ]


renderLinks : String -> Html msg
renderLinks path =
    div []
        [ a [ class "links", href ("#r/" ++ path) ] [ text path ]
        , br [] []
        ]
