module Models exposing (Flags, Mode, Model, Msg(..), Post, PostHint(..), PostId, PostList, Response, Route(..), SearchHistory, SubReddit)

import Http
import Navigation exposing (Location)


type Msg
    = Posts (Result Http.Error Response)
    | FetchPosts
    | RecordQuery String
    | OnLocationChange Location
    | ChangeSelection String


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


type alias Mode =
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
    , mode : Mode
    }


type alias Response =
    { children : PostList
    , after : String
    , before : String
    }
