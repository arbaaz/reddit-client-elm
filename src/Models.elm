module Models exposing (..)


type PostHint
    = RichVideo
    | Image
    | Link
    | Unknown


type alias Post =
    { id : String
    , imageUrl : String
    , postUrl : String
    , title : String
    , ups : Int
    , postHint : PostHint
    , source : Maybe String
    , mediaUrl : Maybe String
    }


type Route
    = PostRoute SubReddit PostId
    | SubRedditRoute SubReddit
    | NotFoundRoute


type alias SubReddit =
    String


type alias PostId =
    String


type alias PostList =
    List Post


type alias DataStore =
    { after : Maybe String
    , before : Maybe String
    , children : PostList
    }


type alias Model =
    { data : PostList
    , query : String
    , error : String
    , after : String
    , before : String
    , loading : Bool
    , limit : String
    , count : String
    , route : Route
    , history : List String
    }
