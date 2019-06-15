module Update.Settings exposing (countPerPage, savePreferences, toggleAdultMode, toggleAutoPlayMode, toggleGifMode, toggleImageMode)

import Dict exposing (Dict)
import Models exposing (Model, Msg)
import Navigation exposing (modifyUrl)
import Update.Port exposing (setStorage, toGoogleAnalytics)


countPerPage : String -> Model -> ( Model, Cmd Msg )
countPerPage count model =
    let
        settings =
            model.settings
    in
    ( { model | settings = { settings | count = count } }, Cmd.none )


toggleGifMode : Model -> ( Model, Cmd Msg )
toggleGifMode model =
    let
        settings =
            model.settings
    in
    ( { model | settings = { settings | gifMode = not settings.gifMode } }, Cmd.none )


toggleImageMode : Model -> ( Model, Cmd Msg )
toggleImageMode model =
    let
        settings =
            model.settings
    in
    ( { model | settings = { settings | imageMode = not settings.imageMode } }, Cmd.none )


toggleAutoPlayMode : Model -> ( Model, Cmd Msg )
toggleAutoPlayMode model =
    let
        settings =
            model.settings
    in
    ( { model | settings = { settings | autoPlayGif = not settings.autoPlayGif } }, Cmd.none )


toggleAdultMode : Model -> ( Model, Cmd Msg )
toggleAdultMode model =
    let
        settings =
            model.settings
    in
    ( { model | settings = { settings | adultMode = not settings.adultMode } }, Cmd.none )


savePreferences : Model -> ( Model, Cmd Msg )
savePreferences model =
    ( model, Cmd.batch [ modifyUrl ("#r/" ++ model.query), setStorage { history = Dict.toList model.history, settings = model.settings } ] )
