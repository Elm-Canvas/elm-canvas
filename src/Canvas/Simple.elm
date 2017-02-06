module Canvas.Simple exposing (..)


import Color exposing (Color)
import Canvas exposing(Canvas, Position, DrawOp(..))


--getPixel : Position -> Canvas -> Color
--getPixel position =


fill : Color -> Canvas -> Canvas
fill color canvas =
    Canvas.batch
        [ BeginPath
        , Rect (Position 0 0) (Canvas.getSize canvas)
        , FillStyle color
        , Fill
        ]