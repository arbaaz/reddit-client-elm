module Update.Location exposing (onLocationChange)

import Api exposing (fetchPosts)
import Models exposing (Model, Msg(..), Route(..))
import Navigation exposing (Location)
import Routing exposing (parseLocation, routeParser, router)


onLocationChange : Location -> Model -> ( Model, Cmd Msg )
onLocationChange location model =
    let
        newRoute =
            parseLocation location

        query =
            routeParser newRoute
    in
    case ( model.route, newRoute ) of
        ( Home, SubRedditRoute sub ) ->
            let
                newModel =
                    { model | route = newRoute, query = query }
            in
            ( newModel, fetchPosts newModel )

        _ ->
            ( { model | route = newRoute }, Cmd.none )
