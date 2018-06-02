module Models.Post exposing (..)


type alias Post =
    { imageUrl : String
    , postUrl : String
    , title : String
    , ups : Int
    , source : Maybe String
    }
