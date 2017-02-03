module Main exposing (..)


import Canvas exposing (Size, Position, DrawOp(..))




main =
  Canvas.initialize (Size 400 300)
  |>Canvas.batch
    [ BeginPath
    , Rect (Position 10 10) (Size 370 270)
    , FillStyle "red"
    , Fill
    , BeginPath
    , Rect (Position 20 20) (Size 370 270)
    , FillStyle "blue"
    , Fill
    ]
  |> Canvas.toHtml []
