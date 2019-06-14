module Models exposing (Flags, Mode, Model, Msg(..), Post, PostHint(..), PostId, PostList, Response, Route(..), SearchHistory, Settings, SubReddit, setCount, toggleGif, toggleImageMode, toggleSettings)

import Dict exposing (Dict)
import Http
import Navigation exposing (Location)


type Msg
    = Posts (Result Http.Error Response)
    | FetchPosts
    | RecordQuery String
    | OnLocationChange Location
    | DeleteHistory String
    | FetchRandNsfw
    | SavePreferences
    | ToggleGifMode
    | ToggleImageMode
    | ToggleSettings String
    | CountPerPage String


setCount : String -> Settings -> Settings
setCount count settings =
    { settings | count = count }


toggleGif : Settings -> Settings
toggleGif settings =
    { settings | gifMode = not settings.gifMode }


toggleImageMode : Settings -> Settings
toggleImageMode settings =
    { settings | imageMode = not settings.imageMode }


toggleSettings : String -> Settings -> Settings
toggleSettings field_accessor settings =
    settings


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
    , iframe : String
    , url : String
    }


type Route
    = PostRoute SubReddit PostId
    | SubRedditRoute SubReddit
    | NotFoundRoute
    | Home
    | Preferences


type alias SubReddit =
    String


type alias PostId =
    String


type alias Mode =
    String


type alias PostList =
    List Post


type alias Settings =
    { count : String
    , gifMode : Bool
    , imageMode : Bool
    , autoPlayGif : Bool
    , adultMode : Bool
    }


type alias SearchHistory =
    List ( String, String )


type alias Flags =
    { history : SearchHistory
    , settings : Settings
    }



type alias Model =
    { children : PostList
    , query : String
    , error : String
    , history : Dict String String
    , before : String
    , loading : Bool
    , limit : String
    , count : String
    , route : Route
    , mode : Mode
    , settings : Settings
    }


type alias Response =
    { children : PostList
    , after : String
    , before : String
    , subreddit : String
    }
