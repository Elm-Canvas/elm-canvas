module Types exposing (..)

import Mouse exposing (Position)
import Canvas exposing (Canvas, Pixel)

type Msg 
  = CanvasClick Position
  | MouseUp Position
  | MouseMove Position
  | ShowSwitch

type alias Model =
  { canvas : Canvas
  , mouseDown : Bool
  , mousePosition : Position
  , pixelsToChange : List Pixel
  , show : Bool
  }
