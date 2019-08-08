module Update.Query exposing (fetchRandNsfw, recordQuery)

import Browser.Navigation as Nav
import Models exposing (Model, Msg)



-- import Navigation exposing (modifyUrl)


fetchRandNsfw : Model -> ( Model, Cmd Msg )
fetchRandNsfw model =
    ( { model | loading = True }, Cmd.batch [ Nav.pushUrl model.key "#r/randnsfw" ] )


recordQuery : String -> Model -> ( Model, Cmd Msg )
recordQuery query model =
    ( { model | query = query }, Cmd.none )
