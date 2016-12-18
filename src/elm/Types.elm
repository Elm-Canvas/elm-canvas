module Types exposing (..)

import Mouse exposing (Position)
import Canvas

type Msg 
  = PopulateData
  | DrawError Canvas.Error
  | DrawSuccess
  | HandleMouseDown
  | HandleMouseUp Position
  | MovingTo Position

type alias Model =
  { canvasName    : String
  , mousePosition : Position
  , mouseDown     : Bool
  }
