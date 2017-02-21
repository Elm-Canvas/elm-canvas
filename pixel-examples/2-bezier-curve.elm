module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Canvas exposing (Size, Point, Canvas, DrawOp(..))
import Canvas.Pixel as Pixel
import Html.Attributes exposing (style)
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
                [ ( "width", "400px" )
                , ( "height", "400px" )
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
            , Rect (Point 0 0) size
            , FillStyle Color.blue
            , Fill
            ]
            (Canvas.initialize size)


draws : Int -> List DrawOp
draws resolution =
    Pixel.bezier
        resolution
        Color.red
        (Point 90 90)
        (Point 90 10)
        (Point 10 90)
        (Point 10 10)
