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


type alias PostList =
    List Post


type alias DataStore =
    { after : Maybe String
    , before : Maybe String
    , children : PostList
    }
