module Canvas exposing (..)

import Html exposing (Html, Attribute)
import List
import Native.Canvas


toHtml : List (Attribute msg) -> Html msg
toHtml =
  Native.Canvas.toHtml



