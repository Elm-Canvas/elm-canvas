module Main exposing (..)

import Canvas exposing (Size, Canvas, DrawOp(..))
import Canvas.Point exposing (Point)
import Canvas.Point as Point
import Canvas.Pixel as Pixel
import Html.Attributes exposing (style)
import Color exposing (Color)


main =
    Canvas.toHtml
        [ style
            [ ( "width", "800px" )
            , ( "height", "800px" )
            , ( "image-rendering", "pixelated" )
            ]
        ]
        (Canvas.batch draws canvas)


canvas : Canvas
canvas =
    let
        size =
            Size 5 5
    in
        Canvas.batch
            [ BeginPath
            , Rect (Point.fromInts ( 0, 0 )) size
            , FillStyle Color.blue
            , Fill
            ]
            (Canvas.initialize size)


draws : List DrawOp
draws =
    [ Pixel.put Color.red (Point.fromInts ( 1, 1 ))
    , Pixel.put Color.red (Point.fromInts ( 3, 1 ))
    , Pixel.put Color.red (Point.fromInts ( 1, 3 ))
    , Pixel.put Color.red (Point.fromInts ( 3, 3 ))
    , Pixel.put Color.red (Point.fromInts ( 2, 2 ))
    ]
