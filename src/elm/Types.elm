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
  | AddView Int 
  | RemoveView Int
  | IncreaseRed Int
  | DecreaseRed Int
  | IncreaseGreen Int
  | DecreaseGreen Int
  | IncreaseBlue Int
  | DecreaseBlue Int
  | SwitchGradient Int

type alias Model =
  { canvases : Array Canvas }

type alias Canvas =
  { width         : Int
  , height        : Int
  , color         : (Int, Int, Int)
  , numberOfViews : Int
  , gradient      : Bool
  }