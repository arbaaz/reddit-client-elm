module Routing exposing (matchers, parseLocation, routeParser, router)

import Html exposing (Html)
import Models exposing (Model, Msg(..), Route(..))
import Navigation exposing (Location)
import UrlParser exposing (..)
import View.HomePage exposing (homePage)
import View.NotFound exposing (notFoundView)
import View.Page exposing (page)
import View.Post exposing (renderPost)
import View.Preferences exposing (preferencesView)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map PostRoute (s "r" </> string </> string)
        , map SubRedditRoute (s "r" </> string)
        , map Home (s "home")
        , map Lightbox (s "lb" </> string)
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
            let
                postItem =
                    List.head (List.filter (\m -> m.id == id) model.children)
            in
            case postItem of
                Just post ->
                    Html.div [] []

                Nothing ->
                    Html.div [] []

        Home ->
            homePage model

        Lightbox id ->
            page model

        NotFoundRoute ->
            notFoundView

        Preferences ->
            preferencesView model


routeParser : Route -> String
routeParser route =
    let
        query =
            case route of
                PostRoute sub id ->
                    sub

                SubRedditRoute sub ->
                    sub

                _ ->
                    ""
    in
    query
