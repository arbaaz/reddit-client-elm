module Update.Update exposing (update)

import Api exposing (fetchPosts)
import Dict exposing (Dict)
import Models exposing (Flags, Model, Msg(..), Route(..))
import Navigation exposing (Location, modifyUrl)
import Update.Location
import Update.Port exposing (setStorage)
import Update.Posts
import Update.Settings


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnLocationChange location ->
            Update.Location.onLocationChange location model

        Posts (Ok x) ->
            Update.Posts.postSuccess x model

        Posts (Err err) ->
            Update.Posts.postFail err model

        FetchPosts ->
            Update.Posts.fetchPost model

        -- ( newModel, Cmd.none )
        RecordQuery query ->
            ( { model | query = query }, Cmd.none )

        FetchRandNsfw ->
            let
                newModel =
                    { model | query = "randnsfw", loading = True }
            in
            ( newModel, fetchPosts newModel )

        SavePreferences ->
            Update.Settings.savePreferences model

        CountPerPage count ->
            Update.Settings.countPerPage count model

        ToggleGifMode ->
            Update.Settings.toggleGifMode model

        ToggleImageMode ->
            Update.Settings.toggleImageMode model

        ToggleAutoPlayMode ->
            Update.Settings.toggleAutoPlayMode model

        ToggleAdultMode ->
            Update.Settings.toggleAdultMode model

        DeleteHistory sub ->
            let
                history =
                    Dict.remove sub model.history
            in
            ( { model | history = history }, setStorage { history = Dict.toList history, settings = model.settings } )
