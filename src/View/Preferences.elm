module View.Preferences exposing (preferencesView)

import Html exposing (..)
import Html.Attributes as HA exposing (..)
import Html.Events exposing (on, onClick, onInput)
import Models exposing (Model, Msg(..), SettingsMsg(..))


preferencesView : Model -> Html Msg
preferencesView { settings } =
    div []
        [ div [ class "form-group" ]
            [ label [ class "form-check-label" ] [ text "Results per page" ]
            , input [ onInput (\count -> SettingsAction (CountPerPage count)), value settings.count, class "form-control", type_ "number", HA.maxlength 2 ] []
            ]
        , renderCheckBox settings.gifMode (SettingsAction ToggleGifMode) "toggleGifMode" "Only Gifs"
        , renderCheckBox settings.imageMode (SettingsAction ToggleImageMode) "toggleImageMode" "Image mode"
        , renderCheckBox settings.autoPlayGif (SettingsAction ToggleAutoPlayMode) "toggleAutoPlayGifs" "Auto play gifs"
        , renderCheckBox settings.adultMode (SettingsAction ToggleAdultMode) "toggleAdultMode" "18+"
        , button [ onClick SavePreferences, class "btn btn-outline-success" ] [ text "Save" ]
        ]


renderCheckBox value clickHandler inputTagId labelText =
    div [ class "form-check" ]
        [ input [ onClick clickHandler, checked value, class "form-check-input", type_ "checkbox", id inputTagId ] []
        , label [ class "form-check-label", for inputTagId ] [ text labelText ]
        ]
