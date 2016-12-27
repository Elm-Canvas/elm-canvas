import Html             exposing (p, text)
import Html.Attributes  exposing (class)
import List             exposing (repeat, map, range, concat)
import Array            exposing (Array, fromList, push, get, set)
import Types            exposing (..)
import View             exposing (view)
import Maybe            exposing (withDefault)
import Canvas           exposing (Pixel)
import Color            exposing (Color, rgb)
import Task             exposing (attempt)
import Mouse            exposing (Position)
import Line             exposing (line)
import Ports            exposing (populate)
import Debug            exposing (log)

(.) = flip 

initModel : Model
initModel =
  { pixelsToChange = []
  , canvas = 
    { id = "the-canvas"
    , imageData =
      let
        width = 300
        height = 300
      in
      { width = width
      , height = height
      , data = 
          [ 0, 0, 0, 255 ]
          |>repeat (width * height)
          |>concat
      }
    }
  }


main =
  Html.program
  { init          = (initModel, populate "the-canvas") 
  , view          = view
  , update        = update
  , subscriptions = always Sub.none
  }


--subscriptions : Model -> Sub Msg
--subscriptions {mouseDown} =
--  if mouseDown then
--    Sub.batch 
--    [ Mouse.moves SetPosition
--    , Mouse.ups HandleMouseUp 
--    ]
--  else
--    Mouse.moves SetPosition


update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of 
    Draw ->
      (model, Cmd.none)

    ClickCanvas i ->
      let _ = log "I!" i in
      (model, Cmd.none)


