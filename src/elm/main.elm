import Html             exposing (p, text)
import Html.Attributes  exposing (class)
import Html.App         as App
import Types            exposing (..)
import Ports            exposing (..)
import View             exposing (view)
import Debug exposing (log)

main =
  App.program
  { init          = (Model "Elm 0.17 Gulp Coffeescript Stylus Lodash Browserify Boilerplate!", Cmd.none) 
  , view          = view
  , update        = update
  , subscriptions = subscriptions
  }

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of 

    Draw ->
      (model, draw "get draw!")




