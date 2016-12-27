module Types exposing (..)

import Mouse exposing (Position)
import Canvas

type Msg 
  = Draw
  | ClickCanvas Int

type alias Model =
  { canvas : Canvas.Canvas
  , pixelsToChange : List Canvas.Pixel
  }
