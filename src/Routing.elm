module Routing exposing (matchers, parseLocation, routeParser, router)

-- import View.Post exposing (renderPost)

import Html exposing (Html)
import Models exposing (Model, Msg(..), Route(..))
import Navigation exposing (Location)
import UrlParser exposing (..)
import View.HomePage exposing (homePage)
import View.NotFound exposing (notFoundView)
import View.Page exposing (page)
import View.Preferences exposing (preferencesView)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map PostRoute (s "r" </> string </> string)
        , map SubRedditRoute (s "r" </> string)
        , map Home (s "home")
        , map Preferences (s "preferences")
        ]


parseLocation : Location -> Route
parseLocation location =
    case parseHash matchers location of
        Just route ->
            route

        Nothing ->
            Home


router : Model -> Html Msg
router model =
    case model.route of
        SubRedditRoute sub ->
            page model

        PostRoute sub id ->
            page model

        Home ->
            homePage model

        NotFoundRoute ->
            notFoundView

        Preferences ->
            preferencesView model


routeParser : Route -> String
routeParser route =
    case route of
        PostRoute sub id ->
            sub

        SubRedditRoute sub ->
            sub

        _ ->
            "tinder"
