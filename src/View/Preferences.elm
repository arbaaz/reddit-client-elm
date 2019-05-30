module View.Preferences exposing (preferencesView)

import Html exposing (..)
import Html.Attributes as HA exposing (..)
import Html.Events exposing (on, onClick, onInput, onWithOptions)
import Models exposing (Model, Msg(CountPerPage, SavePreferences, ToggleGifMode))


preferencesView : Model -> Html Msg
preferencesView model =
    div []
        [ div [ class "form-group" ]
            [ label [ class "form-check-label" ] [ text "Results per page" ]
            , input [ onInput CountPerPage, value model.settings.count, class "form-control", type_ "number", HA.maxlength 2 ] []
            ]
        , div [ class "form-check" ]
            [ input [ onClick ToggleGifMode, checked model.settings.gifMode, class "form-check-input", type_ "checkbox", id "defaultCheck1" ] []
            , label [ class "form-check-label", for "defaultCheck1" ] [ text "Gif mode" ]
            ]
        , button [ onClick SavePreferences, class "btn btn-outline-success" ] [ text "Save" ]
        ]
