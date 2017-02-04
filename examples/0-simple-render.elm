module Main exposing (..)

import Canvas exposing (Size, Position, DrawOp(..))
import Color exposing (Color)


main =
    Canvas.initialize (Size 400 300)
        |> (Canvas.batch << List.concat)
            [ drawRectangle (Position 10 10) Color.red
            , drawRectangle (Position 30 30) (Color.rgba 0 0 255 0.5)
            ]
        |> Canvas.toHtml []


drawRectangle : Position -> Color -> List DrawOp
drawRectangle position color =
    [ BeginPath
    , Rect position (Size 370 270)
    , FillStyle color
    , Fill
    ]
