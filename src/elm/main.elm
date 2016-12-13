import Html             exposing (p, text)
import Html.Attributes  exposing (class)
import Html.App         as App
import Types            exposing (..)
import Ports            exposing (..)
import View             exposing (view)
import Debug            exposing (log)

main =
  App.program
  { init          = (0, Cmd.none) 
  , view          = always view
  , update        = update
  , subscriptions = subscriptions
  }

subscriptions : Int -> Sub Msg
subscriptions model =
  Sub.none

update : Msg -> Int -> (Int, Cmd Msg)
update message model =
  case message of 

    Draw ->
      (0, draw ())




