module Models exposing (..)

import Http
import Navigation exposing (Location)


type Msg
    = Posts (Result Http.Error PostList)
    | FetchPosts
    | RecordQuery String
    | NextPosts
    | PrevPosts
    | OnLocationChange Location


type alias Flags =
    String


type PostHint
    = Video
    | Image
    | Link
    | Unknown


type alias Post =
    { id : String
    , imageUrl : String
    , postUrl : String
    , title : String
    , ups : Int
    , postHint : String
    , source : String
    , mediaUrl : String
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


type alias SearchHistory =
    List String


type alias Model =
    { children : PostList
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
