module Update.Update exposing (update)

import Models exposing (Model, Msg(..))
import Update.Location
import Update.Posts
import Update.Query
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

        RecordQuery query ->
            Update.Query.recordQuery query model

        FetchRandNsfw ->
            Update.Query.fetchRandNsfw model

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
            Update.Settings.deleteHistory sub model
