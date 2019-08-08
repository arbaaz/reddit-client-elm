module Models exposing (Flags, Mode, Model, Msg(..), Post, PostHint(..), PostId, PostList, Response, Route(..), SearchHistory, Settings, SettingsMsg(..), SubReddit)

import Browser
import Browser.Navigation as Nav
import Dict exposing (Dict)
import Http
import Url



-- import Navigation exposing (Location)


type Msg
    = Posts (Result Http.Error Response)
    | FetchPosts
    | RecordQuery String
    | FetchRandNsfw
    | SavePreferences
    | DeleteHistory String
    | SettingsAction SettingsMsg
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


type SettingsMsg
    = ToggleGifMode
    | ToggleImageMode
    | ToggleAutoPlayMode
    | ToggleAdultMode
    | CountPerPage String


type PostHint
    = Video
    | Image
    | Link
    | Unknown
    | Gif


type alias Post =
    { id : String
    , imageUrl : String
    , postUrl : String
    , title : String
    , ups : Int
    , postHint : PostHint
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
    , key : Nav.Key
    , url : Url.Url
    }


type alias Response =
    { children : PostList
    , after : String
    , before : String
    , subreddit : String
    }
