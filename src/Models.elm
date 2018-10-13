module Models exposing (..)


type alias Post =
    { id : String
    , imageUrl : String
    , postUrl : String
    , title : String
    , ups : Int
    , source : Maybe String
    }


type Route
    = PostRoute PostId
    | NotFoundRoute


type alias PostId =
    String
