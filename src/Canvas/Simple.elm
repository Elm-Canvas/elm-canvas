module Canvas.Simple 
    exposing 
        ( fill
        )


import Color exposing (Color)
import Canvas exposing(Canvas, Position, DrawOp(..))



fill : Color -> Canvas -> Canvas
fill color canvas =
    Canvas.batch
        [ BeginPath
        , Rect (Position 0 0) (Canvas.getSize canvas)
        , FillStyle color
        , Fill
        ]