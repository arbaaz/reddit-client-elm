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

        newModel =
            { model | route = newRoute, query = query, loading = True }
    in
    case ( model.route, newRoute ) of
        ( Home, SubRedditRoute sub ) ->
            ( newModel, fetchPosts newModel )

        ( SubRedditRoute oldSub, SubRedditRoute newSub ) ->
            ( newModel, fetchPosts newModel )

        _ ->
            ( { newModel | loading = False }, Cmd.none )
