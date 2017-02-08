module Canvas.Pixel
    exposing 
        ( put
        , putMany
        , line
        , toPosition
        , toPoint
        , Position
        )

import Canvas exposing (Canvas, Size, Point, DrawOp(..))
import Color exposing (Color)
import Array exposing (Array)


type alias Position =
    { x : Int, y : Int }


toPoint : Position -> Point
toPoint {x, y} =
    Point (toFloat x) (toFloat y)


toPosition : Point -> Position
toPosition {x, y} =
    Position (round x) (round y)


put : Color -> Position -> List DrawOp
put color position =
    List.singleton <| putHelp (color, position)


putMany : List (Color, Position) -> List DrawOp
putMany =
    List.map putHelp


putHelp : (Color, Position) -> DrawOp
putHelp (color, position) =
    PutImageData
        (fromColor color)
        (Size 1 1)
        (toPoint position)


fromColor : Color -> Array Int
fromColor color =
    let
        {red, green, blue, alpha} =
            Color.toRgb color
    in
        Array.fromList
            [ red
            , green
            , blue
            , round (alpha * 255) 
            ]


-- Brensenham Line Algorithm


type alias BresenhamStatics = 
  { finish : Position
  , sx : Int
  , sy : Int
  , dx : Float
  , dy : Float 
  }


line : Color -> Position -> Position -> List DrawOp
line color p q =
  let
    dx = (toFloat << abs) (q.x - p.x)
    dy = (toFloat << abs) (q.y - p.y)

    sx = if p.x < q.x then 1 else -1
    sy = if p.y < q.y then 1 else -1

    error =
      (if dx > dy then dx else -dy) / 2

    statics = 
      BresenhamStatics q sx sy dx dy 
  in
  bresenhamLineLoop statics error p []
    |> List.map ((,) color)
    |> putMany


bresenhamLineLoop : BresenhamStatics -> Float -> Position -> List Position -> List Position
bresenhamLineLoop statics error p positions =
  let 
    positions_ = p :: positions 
    {sx, sy, dx, dy, finish} = statics
  in
  if (p.x == finish.x) && (p.y == finish.y) then 
    positions_
  else
    let
      (dErrX, x) =
        if error > -dx then (-dy, sx + p.x)
        else (0, p.x)

      (dErrY, y) =
        if error < dy then (dx, sy + p.y)
        else (0, p.y)

      error_ = error + dErrX + dErrY
    in
      bresenhamLineLoop statics error_ (Position x y) positions_






