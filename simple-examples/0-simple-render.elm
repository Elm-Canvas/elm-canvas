module Main exposing (..)


import Canvas exposing (Size, Position, Canvas)
import Canvas.Simple exposing (Draw)
import Canvas.Simple as Simple


main =
    (Canvas.toHtml [] << draw) 
        (Canvas.initialize (Size 600 400))


draw : Canvas -> Canvas
draw =
    Simple.batch [ fillRed, drawText ]


fillRed : Draw
fillRed =
    Simple.fill Color.red


drawText : Draw
drawText =
    Simple.filledText
        "Elm-Canvas"
        "84px sans-serif" 
        (Color.rgba 255 255 0 0.75) 
        (Position 50 192)