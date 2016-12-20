module Line exposing (..)

import Canvas exposing (Coordinate, Pixel)
import Mouse exposing (Position)


line : Position -> Position -> List Coordinate
line p0 p1 =
  bresenhamLine (coordinate p0) (coordinate p1)


coordinate : Position -> Coordinate
coordinate {x, y} = (x, y)


type alias BresenhamStatics = 
  { sx : Int, sy : Int, dx : Float, dy : Float, x1 : Int, y1 : Int}


bresenhamLine : Coordinate -> Coordinate -> List Coordinate
bresenhamLine (x0, y0) (x1, y1) =
  let
    dx = (toFloat << abs) (x1 - x0)
    sx = if x0 < x1 then 1 else -1
    dy = (toFloat << abs) (y1 - y0)
    sy = if y0 < y1 then 1 else -1

    error =
      (if dx > dy then dx else -dy) / 2

    statics = 
      BresenhamStatics sx sy dx dy x1 y1
  in
  bresenhamLineLoop statics error (x0, y0) []


bresenhamLineLoop : BresenhamStatics -> Float -> Coordinate -> List Coordinate -> List Coordinate
bresenhamLineLoop statics error (x0, y0) coordinates =
  let 
    coordinates_ = (x0, y0) :: coordinates 
    {sx, sy, dx, dy, x1, y1} = statics
  in
  if (x0 == x1) && (y0 == y1) then coordinates_
  else
    let
      (dErrX, x0_) =
        if error > -dx then (-dy, sx + x0)
        else (0, x0)

      (dErrY, y0_) =
        if error < dy then (dx, sy + y0)
        else (0, y0)

      error_ = error + dErrX + dErrY
    in
    bresenhamLineLoop statics error_ (x0_, y0_) coordinates_
 