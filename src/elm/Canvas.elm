module Canvas exposing (..)

import Html exposing (Html, Attribute)
import Native.Canvas

canvas : List (Attribute msg) -> Int -> Int -> List Int -> Html msg
canvas attr width height data =
  Native.Canvas.canvas attr width height data



