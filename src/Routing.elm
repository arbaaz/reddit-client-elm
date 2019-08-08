module Routing exposing (matchers, routeParser, router)

-- import UrlParser exposing (..)
-- import Navigation exposing (Location)

import Html exposing (Html)
import Models exposing (Model, Msg(..), Route(..))
import Url
import Url.Parser exposing ((</>), Parser, int, map, oneOf, s, string)
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



-- parseLocation : Url.Url -> Route
-- parseLocation url =
--     case matchers url of
--         Just route ->
--             route
--         Nothing ->
--             Home


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
