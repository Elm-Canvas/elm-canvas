port module Ports exposing (..)

import Types exposing (..)

port draw : String -> Cmd msg

port response : (String -> msg) -> Sub msg