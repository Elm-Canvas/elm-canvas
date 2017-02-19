module Main exposing (..)

import Canvas exposing (Size, Point, DrawOp(..))
import Color exposing (Color)


main =
    Canvas.initialize (Size 400 300)
        |> Canvas.batch drawOps
        |> Canvas.toHtml []


drawOps : List DrawOp
drawOps =
    List.concat
        [ drawRectangle (Point 10 10) Color.red
        , drawRectangle (Point 30 30) (Color.rgba 0 0 255 0.5)
        , [ FillStyle Color.white
          , Font "48px sans-serif"
          , FillText "Elm Canvas" (Position 50 120)
          ]
        ]


drawRectangle : Point -> Color -> List DrawOp
drawRectangle position color =
    [ BeginPath
    , Rect position (Size 370 270)
    , FillStyle color
    , Fill
    ]
