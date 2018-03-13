module Main exposing (..)

import Html exposing (Html)
import Canvas exposing (Size, Point, Canvas, Style(Color), DrawOp(..))
import Color exposing (Color)


main : Html a
main =
    Canvas.initialize (Size 400 300)
        |> Canvas.draw drawing
        |> Canvas.toHtml []


drawing : DrawOp
drawing =
    [ rectangle (Point 10 10) Color.red
    , rectangle (Point 30 30) (Color.rgba 0 0 255 0.5)
    , FillStyle <| Color Color.white
    , Font "48px sans-serif"
    , FillText "Elm Canvas" (Point 50 120)
    ]
        |> Canvas.batch


rectangle : Point -> Color -> DrawOp
rectangle point color =
    [ BeginPath
    , Rect point (Size 370 270)
    , FillStyle <| Color color
    , Fill
    ]
        |> Canvas.batch
