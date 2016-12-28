module Types exposing (..)

import Mouse exposing (Position)
import Canvas

type Msg 
  = Draw
  | ClickCanvas Position

type alias Model =
  { canvas : Canvas.Canvas
  }
