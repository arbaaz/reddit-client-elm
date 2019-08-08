module Update.Location exposing (onLocationChange)

-- import Navigation exposing (Location)

import Api exposing (fetchPosts)
import Models exposing (Model, Msg(..), Route(..))
import Routing exposing (routeParser, router)
import Url


onLocationChange : Url.Url -> Model -> ( Model, Cmd Msg )
onLocationChange url model =
    let
        -- newRoute =
        --     parseLocation location
        newRoute =
            NotFoundRoute

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
