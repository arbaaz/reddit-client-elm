module Update.Query exposing (fetchRandNsfw, recordQuery)

import Api exposing (fetchPosts)
import Models exposing (Model, Msg)


fetchRandNsfw : Model -> ( Model, Cmd Msg )
fetchRandNsfw model =
    let
        newModel =
            { model | query = "randnsfw", loading = True }
    in
    ( newModel, fetchPosts newModel )


recordQuery : String -> Model -> ( Model, Cmd Msg )
recordQuery query model =
    ( { model | query = query }, Cmd.none )
