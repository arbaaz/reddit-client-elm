module Models exposing (..)

import Http
import Navigation exposing (Location)


type Msg
    = Posts (Result Http.Error DataStore)
    | FetchPosts
    | RecordQuery String
    | NextPosts
    | PrevPosts
    | OnLocationChange Location


type alias Flags =
    String


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


type alias SearchHistory =
    List String


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
    , history : SearchHistory
    }
