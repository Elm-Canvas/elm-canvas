module Types exposing (..)

import Mouse exposing (Position)
import Canvas

type Msg 
  = Draw
  | DrawError (List Canvas.Pixel) Canvas.Error
  | DrawSuccess
  | HandleMouseDown
  | HandleMouseUp Position
  | SetPosition Position
  | AppendPixels (List Canvas.Pixel)
  | Populate

type alias Model =
  { canvasId          : String
  , mousePosition     : Position
  , mouseDown         : Bool
  , pixelsToChange    : List Canvas.Pixel
  , canvasCoordinates : (Int, Int)
  }
