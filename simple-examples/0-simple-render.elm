module Main exposing (..)

import Canvas exposing (Size, Position, Canvas)
import Canvas.Simple exposing (Draw)
import Canvas.Simple as Draw
import Color exposing (Color)


main =
    Canvas.initialize (Size 400 300)
        |> Draw.batch draws
        |> Canvas.toHtml []


draws : List Draw
draws =
    [ drawRectangle (Position 10 10) Color.red
    , drawRectangle (Position 30 30) (Color.rgba 0 0 255 0.5)
    , Draw.filledText
        "Elm-Canvas"
        "56px sans-serif"
        Color.white
        (Position 50 120)
    ]


drawRectangle : Position -> Color -> Draw
drawRectangle position color =
    Draw.filledRectangle color position (Size 370 270)
