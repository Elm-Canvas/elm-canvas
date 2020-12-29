module Main exposing (..)

import Canvas exposing (Canvas, Point, Size)
import Color exposing (Color)
import Ctx exposing (Ctx, Style(Color))
import Html exposing (Html)


main : Html a
main =
    [ rectangle { x = 10, y = 10 } Color.red
    , rectangle { x = 30, y = 30 } (Color.rgba 0 0 255 0.5)
    , Ctx.fillStyle <| Color Color.white
    , Ctx.font "48px sans-serif"
    , Ctx.fillText "Elm Canvas" { x = 50, y = 120 }
    ]
        |> Ctx.draw canvas
        |> Canvas.toHtml []


canvas : Canvas
canvas =
    { width = 400
    , height = 300
    }
        |> Canvas.initialize


rectangle : Point -> Color -> Ctx
rectangle point color =
    [ Ctx.beginPath
    , Ctx.rect point { width = 370, height = 270 }
    , Ctx.fillStyle <| Color color
    , Ctx.fill
    ]
        |> Ctx.batch
