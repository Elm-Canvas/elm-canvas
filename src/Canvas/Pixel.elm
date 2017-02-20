module Canvas.Pixel
    exposing
        ( put
        , putMany
        , line
        , rectangle
        , bezier
        )

import Canvas exposing (Canvas, Size, Point, DrawOp(..))
import Color exposing (Color)
import Array exposing (Array)

import Debug exposing (log)


put : Color -> Point -> DrawOp
put color point =
    putHelp ( color, point )


putMany : List ( Color, Point ) -> List DrawOp
putMany =
    List.map putHelp


putHelp : ( Color, Point ) -> DrawOp
putHelp ( color, point ) =
    PutImageData
        (fromColor color)
        (Size 1 1)
        point


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


rectangle : Color -> Point -> Size -> List DrawOp
rectangle color { x, y } { width, height } =
    let
        x1 =
            x + toFloat width

        y1 =
            y + toFloat height
    in
        List.concat
            [ line color (Point x y) (Point (x1 - 1) y)
            , line color (Point x y) (Point x (y1 - 1))
            , line color (Point x1 y1) (Point x y1)
            , line color (Point x1 y1) (Point x1 y)
            ]



bezier : Int -> Color -> Point -> Point -> Point -> Point -> List DrawOp
bezier resolution color p0 p1 p2 p3 =
    let
        points = 
            bezierLoop resolution 0 p0 p1 p2 p3 []
    in
        List.map2 (,) points (List.drop 1 points)
            |> List.map (applyLine color)
            |> List.concat


applyLine : Color -> (Point, Point) -> List DrawOp
applyLine  color ( p0, p1 ) =
    line color p0 p1


bezierLoop : Int -> Int -> Point -> Point -> Point -> Point -> List Point -> List Point
bezierLoop seg i p0 p1 p2 p3 points =
    let
        points_ =
            (calcBezierPoint seg i p0 p1 p2 p3) :: points
    in
        if i < seg then
            bezierLoop seg (i + 1) p0 p1 p2 p3 points_
        else
            points_



calcBezierPoint : Int -> Int -> Point -> Point -> Point -> Point -> Point
calcBezierPoint seg i p0 p1 p2 p3 =
    let
        (a, b, c, d) =
            calcBezier seg i
    in
        Point
            ( a * p0.x + b * p1.x + c * p2.x + d * p3.x)
            ( a * p0.y + b * p1.y + c * p2.y + d * p3.y)


calcBezier : Int -> Int -> (Float, Float, Float, Float)
calcBezier seg i =
    let
        a = 
            (toFloat i) / (toFloat seg)

        b =
            1 - a
    in
        ( b^3
        , 3 * b^2 * a
        , 3 * a^2 * b
        , a^3
        )


{- Brensenham Line Algorithm

   f stands for finish
   s stands for step
   d stands for delta (change)

   Basically, along a line, when the difference between
   x and x + i exceeds dx, increment by sx.

-}


type alias LineStatics =
    { fx : Int
    , fy : Int
    , sx : Int
    , sy : Int
    , dx : Float
    , dy : Float
    }


line : Color -> Point -> Point -> List DrawOp
line color p q =
    let
        px =
            floor p.x

        py =
            floor p.y

        qx =
            floor q.x

        qy =
            floor q.y

        ( statics, error ) =
            lineInit qx qy px py
    in
        lineLoop statics error ( px, py ) []
            |> List.map (toPointAndColor color)
            |> putMany


toPointAndColor : Color -> ( Int, Int ) -> (Color, Point)
toPointAndColor color ( x, y ) =
    (color, Point (toFloat x) (toFloat y))


lineInit : Int -> Int -> Int -> Int -> ( LineStatics, Float )
lineInit x0 y0 x1 y1 =
    let
        dx =
            (toFloat << abs) (x0 - x1)

        dy =
            (toFloat << abs) (y0 - y1)

        sx =
            if x0 > x1 then
                1
            else
                -1

        sy =
            if y0 > y1 then
                1
            else
                -1

        error =
            if dx > dy then
                dx / 2
            else
                -dy / 2
    in
        ( LineStatics x0 y0 sx sy dx dy, error )


lineLoop : LineStatics -> Float -> ( Int, Int ) -> List ( Int, Int ) -> List ( Int, Int )
lineLoop statics error ( x, y ) points =
    if (x == statics.fx) && (y == statics.fy) then
        ( x, y ) :: points
    else
        let
            ( error_, q ) =
                calcError statics error ( x, y )
        in
            lineLoop statics error_ q (( x, y ) :: points)


calcError : LineStatics -> Float -> ( Int, Int ) -> ( Float, ( Int, Int ) )
calcError { sx, sy, dx, dy } error ( x_, y_ ) =
    let
        ( errX, x ) =
            if error > -dx then
                ( -dy, sx + x_ )
            else
                ( 0, x_ )

        ( errY, y ) =
            if error < dy then
                ( dx, sy + y_ )
            else
                ( 0, y_ )
    in
        ( error + errX + errY, ( x, y ) )
