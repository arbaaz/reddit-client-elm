module Routing exposing (fromUrl, parser, routeParser, router)

-- import UrlParser exposing (..)
-- import Navigation exposing (Location)

import Html exposing (Html)
import Models exposing (Model, Msg(..), Route(..))
import Url
import Url.Parser as Parser exposing ((</>), Parser, int, map, oneOf, s, string, top)
import View.HomePage exposing (homePage)
import View.NotFound exposing (notFoundView)
import View.Page exposing (page)
import View.Preferences exposing (preferencesView)


parser : Parser (Route -> a) a
parser =
    oneOf
        [ map Home top
        , map PostRoute (s "r" </> string </> string)
        , map SubRedditRoute (s "r" </> string)
        , map Preferences (s "preferences")
        ]


fromUrl : Url.Url -> Route
fromUrl url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> Parser.parse parser
        |> Maybe.withDefault Home


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
