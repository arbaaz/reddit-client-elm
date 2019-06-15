port module Update.Port exposing (setStorage, toGoogleAnalytics)

import Models exposing (Flags)


port setStorage : Flags -> Cmd msg


port toGoogleAnalytics : String -> Cmd msg
