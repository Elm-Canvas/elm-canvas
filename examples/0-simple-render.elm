module Main exposing (..)

import Canvas exposing (Size, Position, DrawOp(..))


main =
    Canvas.initialize (Size 400 300)
        |> (Canvas.batch << List.concat)
            [ drawRectangle (Position 10 10) (Size 370 270) "red"
            , drawRectangle (Position 30 30) (Size 370 270) "blue"
            ]
        |> Canvas.toHtml []


drawRectangle : Position -> Size -> String -> List DrawOp
drawRectangle position size color =
    [ BeginPath
    , Rect position size
    , FillStyle color
    , Fill
    ]

    