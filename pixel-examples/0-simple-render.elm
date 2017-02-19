module Main exposing (..)

import Canvas exposing (Size, Point, Canvas, DrawOp(..))
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
    <|
        Canvas.batch draws canvas


canvas : Canvas
canvas =
    let
        size =
            Size 5 5
    in
        Canvas.initialize size
            |> Canvas.batch
                [ BeginPath
                , Rect (Point 0 0) size
                , FillStyle Color.blue
                , Fill
                ]


draws : List DrawOp
draws =
    List.map
        (Pixel.put Color.red)
        [ Point 1 1
        , Point 3 1
        , Point 1 3
        , Point 3 3
        , Point 2 2
        ]
