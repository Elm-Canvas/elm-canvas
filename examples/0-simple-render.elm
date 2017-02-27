module Main exposing (..)

import Canvas exposing (Size, DrawOp(..))
import Canvas.Point exposing (Point)
import Canvas.Point as Point
import Color exposing (Color)


main =
    Canvas.initialize (Size 400 300)
        |> Canvas.batch drawOps
        |> Canvas.toHtml []


drawOps : List DrawOp
drawOps =
    List.concat
        [ drawRectangle (Point.fromInts ( 10, 10 )) Color.red
        , drawRectangle (Point.fromInts ( 30, 30 )) (Color.rgba 0 0 255 0.5)
        , [ FillStyle Color.white
          , Font "48px sans-serif"
          , FillText "Elm Canvas" (Point.fromInts ( 50, 120 ))
          ]
        ]


drawRectangle : Point -> Color -> List DrawOp
drawRectangle point color =
    [ BeginPath
    , Rect point (Size 370 270)
    , FillStyle color
    , Fill
    ]
