module Canvas exposing (..)

import Html exposing (Html, Attribute)
import List exposing (map)
import Array exposing (Array, repeat, fromList)
import Dict exposing (Dict)
import Native.Canvas

canvas : List (Attribute msg) -> Int -> Int -> List Int -> Html msg
canvas attr width height data =
  Native.Canvas.canvas attr width height data

toHtml : List (Attribute msg) -> Int -> Int -> Html msg
toHtml attr width height =
  Native.Canvas.toHtml attr width height

type alias Coordinates = (Int, Int)
type alias Color       = (Int, Int, Int, Int)
type alias Pixel       = (Coordinates, Color)
type alias Index       = Int
type alias Id          = String

type Msg 
  = SetPixels Id (List Pixel)


type alias Model =
  { canvases : Dict Id Canvas }


type alias Canvas = 
  { width  : Int
  , height : Int
  , data   : Array Int
  }


init : Int -> Int -> (Canvas, Cmd Msg)
init width height =
  let
    data = repeat (width * height * 4) 0
  in
  (Canvas width height data, Cmd.none)

coordinatesToIndex : Int -> Int -> Coordinates -> Index 
coordinatesToIndex width height (x,y) =
  x + (width * y)

--setPixels : Array Int -> Index ->


--update : Msg -> Model -> (Model, Cmd Msg)
--update message model =
--  case message of

--    SetPixels canvasId pixels ->
--      let
--        pixels_ =
--          map (snd >> )
--      in


