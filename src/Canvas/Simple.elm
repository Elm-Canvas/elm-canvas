module Canvas.Simple
    exposing
        ( fill
        , filledText
        , batch
        , Draw
        )

import Color exposing (Color)
import Canvas exposing (Canvas, Position, DrawOp(..))


type alias Draw 
    = Canvas -> (List DrawOp)


fill : Color -> Draw
fill color canvas =
    [ BeginPath
    , Rect (Position 0 0) (Canvas.getSize canvas)
    , FillStyle color
    , Fill
    ]


filledText : String -> String -> Color -> Position -> Draw
filledText content style color position =
    always 
        [ FillStyle color 
        , Font style
        , FillText content position
        ]


batch : List (Canvas -> (List DrawOp)) -> Canvas -> Canvas
batch makeDrawOps canvas =
    Canvas.batch (batchHelp makeDrawOps canvas) canvas


batchHelp :List (Canvas -> (List DrawOp)) -> Canvas -> List DrawOp
batchHelp makeDrawOps canvas =
    List.map ((|>) canvas) makeDrawOps |> List.concat