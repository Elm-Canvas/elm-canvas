module Canvas.Pixel
    exposing 
        ( put
        , putMany
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


---- Brensenham Line Algorithm


--type alias BresenhamStatics = 
--  { fx : Int   -- Finish 
--  , fy : Int   
--  , sx : Int   -- Step
--  , sy : Int
--  , dx : Float -- Change
--  , dy : Float 
--  }


--line : Color -> Position -> Position -> List Position
--line color position0 position1 =
--    lineLoop (makeStatics position0 position1) []
--        |> List.map ((,) color)
--        |> putMany


--lineLoop : (Float, Position, BresenhamStatics) -> List Position -> List Position
--lineLoop (error, position0, statics) positions =
--    if incrementCondition statics position0 then 
--        (position0 :: positions)
--    else
--        let 
--            (error_, position1) =
--                calcErrors error statics position0
--        in
--            lineLoop (error_, position1, statics) (position0 :: positions)


--makeStatics : Position -> Position -> (Float, Position, BresenhamStatics)
--makeStatics position0 position1 =
--    BresenhamStatics
--        position1.x
--        position1.y
--        (if position0.x < position1.x then 1 else -1)
--        (if position0.y < position1.y then 1 else -1)
--        ((toFloat << abs) (position1.x - position0.x))
--        ((toFloat << abs) (position1.y - position0.y))

--        |> (,,) 
--            ((if dx > dy then dx else -dy) / 2) 
--            position0


--incrementCondition : BresenhamStatics -> Position -> Bool
--incrementCondition {fx, fy} {x, y} =
--    (x == fx) && (y == fy)


--calcErrors : Float -> BresenhamStatics -> Position -> (Float, Position)
--calcErrors error {dx, dy, sx, sy} position =
--    let
--        (dErrX, x) =
--            if error > -dx then 
--                (-dy, sx + position.x)
--            else 
--                (0, position.x)

--        (dErrY, y) =
--            if error < dy then 
--                (dx, sy + position.y)
--            else 
--                (0, position.y)

--    in
--        (error + dErrX + dErrY, Position x y)




