module Canvas.Pixel
    exposing
        ( put
        , putMany
        , line
        , rectangle
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
toPoint { x, y } =
    Point (toFloat x) (toFloat y)


toPosition : Point -> Position
toPosition { x, y } =
    Position (round x) (round y)


put : Color -> Position -> List DrawOp
put color position =
    [ putHelp ( color, position ) ]


putMany : List ( Color, Position ) -> List DrawOp
putMany =
    List.map putHelp


putHelp : ( Color, Position ) -> DrawOp
putHelp ( color, position ) =
    PutImageData
        (fromColor color)
        (Size 1 1)
        (toPoint position)


fromColor : Color -> Array Int
fromColor color =
    let
        { red, green, blue, alpha } =
            Color.toRgb color
    in
        Array.fromList
            [ red
            , green
            , blue
            , round (alpha * 255)
            ]


rectangle : Color -> Position -> Size -> List DrawOp
rectangle color { x, y } { width, height } =
    let
        x1 =
            x + width

        y1 =
            y + height
    in
        List.concat
            [ line color (Position x y) (Position (x1 - 1) y)
            , line color (Position x y) (Position x (y1 - 1))
            , line color (Position x1 y1) (Position x y1)
            , line color (Position x1 y1) (Position x1 y)
            ]


-- Brensenham Line Algorithm

-- f stands for finish
-- s stands for step
-- d stands for delta (change)

-- basically : increment by delta, 

type alias LineStatics =
    { fx : Int
    , fy : Int
    , sx : Int
    , sy : Int
    , dx : Float
    , dy : Float
    }


line : Color -> Position -> Position -> List DrawOp
line color p q =
    let
        dx =
            (toFloat << abs) (q.x - p.x)

        dy =
            (toFloat << abs) (q.y - p.y)

        sx =
            if p.x < q.x then
                1
            else
                -1

        sy =
            if p.y < q.y then
                1
            else
                -1

        error =
            if dx > dy then
                dx / 2
            else
                -dy / 2
    in
        lineLoop (LineStatics q.x q.y sx sy dx dy) error p []
            |> List.map ((,) color)
            |> putMany


lineLoop : LineStatics -> Float -> Position -> List Position -> List Position
lineLoop statics error p positions =
    if (p.x == statics.fx) && (p.y == statics.fy) then
        p :: positions
    else
        let
            ( error_, q ) =
                calcError statics error p
        in
            lineLoop statics error_ q (p :: positions)


calcError : LineStatics -> Float -> Position -> ( Float, Position )
calcError { sx, sy, dx, dy } error position =
    let
        ( errX, x ) =
            if error > -dx then
                ( -dy, sx + position.x )
            else
                ( 0, position.x )

        ( errY, y ) =
            if error < dy then
                ( dx, sy + position.y )
            else
                ( 0, position.y )
    in
        ( error + errX + errY, Position x y )
