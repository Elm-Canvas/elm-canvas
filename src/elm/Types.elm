module Types exposing (..)

import Array exposing (Array)

type Msg 
  = Switch
  | AddCanvas
  | UpdateCanvas Int Canvas
  | IncreaseWidth Int
  | DecreaseWidth Int
  | IncreaseHeight Int
  | DecreaseHeight Int

type alias Model =
  { canvases : Array Canvas }

type alias Canvas =
  { width  : Int
  , height : Int
  , data   : List Int
  }