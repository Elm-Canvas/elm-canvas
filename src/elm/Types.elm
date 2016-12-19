module Types exposing (..)

import Mouse exposing (Position)
import Canvas

type Msg 
  = Draw
  | DrawError Canvas.Error
  | DrawSuccess
  | HandleMouseDown
  | HandleMouseUp Position
  | SetPosition Position
  | AppendPixels (List Canvas.Pixel)

type alias Model =
  { canvasId       : String
  , mousePosition  : Position
  , mouseDown      : Bool
  , pixelsToChange : List Canvas.Pixel
  --, canvasData     : List Int
  }
