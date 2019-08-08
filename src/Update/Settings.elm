module Update.Settings exposing (deleteHistory, savePreferences, update)

-- import Navigation exposing (modifyUrl)

import Browser
import Browser.Navigation as Nav
import Dict exposing (Dict)
import Models exposing (Model, Msg, Settings, SettingsMsg(..), SubReddit)
import Update.Port exposing (setStorage, toGoogleAnalytics)


update : SettingsMsg -> Settings -> ( Settings, Cmd Msg )
update msg settings =
    case msg of
        CountPerPage count ->
            ( { settings | count = count }, Cmd.none )

        ToggleGifMode ->
            ( { settings | gifMode = not settings.gifMode }, Cmd.none )

        ToggleImageMode ->
            ( { settings | imageMode = not settings.imageMode }, Cmd.none )

        ToggleAutoPlayMode ->
            ( { settings | autoPlayGif = not settings.autoPlayGif }, Cmd.none )

        ToggleAdultMode ->
            ( { settings | adultMode = not settings.adultMode }, Cmd.none )


savePreferences : Model -> ( Model, Cmd Msg )
savePreferences model =
    ( model, Cmd.batch [ Nav.pushUrl model.key ("#r/" ++ model.query), setStorage { history = Dict.toList model.history, settings = model.settings } ] )


deleteHistory : SubReddit -> Model -> ( Model, Cmd Msg )
deleteHistory sub model =
    let
        history =
            Dict.remove sub model.history
    in
    ( { model | history = history }, setStorage { history = Dict.toList history, settings = model.settings } )
