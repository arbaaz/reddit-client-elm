module View.Preferences exposing (preferencesView)

import Html exposing (..)
import Html.Attributes as HA exposing (..)
import Html.Events exposing (on, onClick, onInput, onWithOptions)
import Models exposing (Model, Msg(CountPerPage, SavePreferences, ToggleGifMode, ToggleImageMode))


preferencesView : Model -> Html Msg
preferencesView model =
    div []
        [ div [ class "form-group" ]
            [ label [ class "form-check-label" ] [ text "Results per page" ]
            , input [ onInput CountPerPage, value model.settings.count, class "form-control", type_ "number", HA.maxlength 2 ] []
            ]
        , div [ class "form-check" ]
            [ input [ onClick ToggleGifMode, checked model.settings.gifMode, class "form-check-input", type_ "checkbox", id "toggleGifMode" ] []
            , label [ class "form-check-label", for "toggleGifMode" ] [ text "Gif mode" ]
            ]
        , div [ class "form-check" ]
            [ input [ onClick ToggleImageMode, checked model.settings.imageMode, class "form-check-input", type_ "checkbox", id "toggleImageMode" ] []
            , label [ class "form-check-label", for "toggleImageMode" ] [ text "Image mode" ]
            ]
        , button [ onClick SavePreferences, class "btn btn-outline-success" ] [ text "Save" ]
        ]
