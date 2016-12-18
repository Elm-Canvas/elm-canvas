module Types exposing (..)

import Canvas

type Msg 
  = Draw
  | DrawError Canvas.Error
  | DrawSuccess String

type alias Model =
  { field : String 
  , canvasName : String
  }
