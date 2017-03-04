module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style, value, type_)
import Html.Events exposing (..)
import Canvas exposing (Size, DrawOp(..), Canvas)
import Canvas.Point exposing (Point)
import Canvas.Point as Point
import Canvas.Pixel as Pixel
import Color


main =
    Html.beginnerProgram
        { model = 5
        , view = view
        , update = update
        }


type Msg
    = ChangeBy Int


update : Msg -> Int -> Int
update message model =
    case message of
        ChangeBy int ->
            int + model


view : Int -> Html Msg
view resolution =
    div
        []
        [ Canvas.toHtml
            [ style
                [ ( "width", "800px" )
                , ( "height", "800px" )
                , ( "image-rendering", "pixelated" )
                ]
            ]
            (Canvas.batch (draws resolution) canvas)
        , input
            [ value "+ 1"
            , onClick (ChangeBy 1)
            , type_ "submit"
            ]
            []
        , input
            [ value "- 1"
            , onClick (ChangeBy -1)
            , type_ "submit"
            ]
            []
        ]


canvas : Canvas
canvas =
    let
        size =
            Size 100 100
    in
        Canvas.batch
            [ BeginPath
            , Rect (Point.fromInts ( 0, 0 )) size
            , FillStyle Color.blue
            , Fill
            ]
            (Canvas.initialize size)


draws : Int -> List DrawOp
draws resolution =
    Pixel.bezier
        resolution
        (Point.fromInts ( 90, 90 ))
        (Point.fromInts ( 90, 10 ))
        (Point.fromInts ( 10, 90 ))
        (Point.fromInts ( 10, 10 ))
        |> List.map (Pixel.put Color.red)
