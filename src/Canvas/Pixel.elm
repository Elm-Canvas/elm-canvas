module Canvas.Pixel
    exposing
        ( put
        , get
        , line
        , rectangle
        , bezier
        , scale
        )

import Canvas exposing (Canvas, Size, DrawOp(..))
import Canvas.Point exposing (Point)
import Canvas.Point as Point
import Color exposing (Color)
import Array exposing (Array)


put : Color -> Point -> DrawOp
put color point =
    PutImageData
        (fromColor color)
        (Size 1 1)
        point


fromColor : Color -> List Int
fromColor color =
    let
        { red, green, blue, alpha } =
            Color.toRgb color
    in
        [ red
        , green
        , blue
        , round (alpha * 255)
        ]


toColor : List Int -> Color
toColor rgba =
    let
        values = 
            Array.fromList rgba
    in
        Color.rgba
            (toColorHelp 0 values)
            (toColorHelp 1 values)
            (toColorHelp 2 values)
            (((toColorHelp 3 values) |> toFloat) / 255)


toColorHelp : Int -> Array Int -> Int
toColorHelp index colorValues =
    Array.get index colorValues |> Maybe.withDefault 0


get : Point -> Canvas -> Color
get point canvas =
    Canvas.getImageData
        point
        (Size 1 1)
        canvas
        |> toColor


rectangle : Point -> Size -> List Point
rectangle point { width, height } =
    let
        ( x, y ) =
            Point.toInts point

        x1 =
            x + width

        y1 =
            y + height
    in
        List.concat
            [ line
                (Point.fromInts ( x, y ))
                (Point.fromInts ( x1 - 1, y ))
            , line
                (Point.fromInts ( x, y ))
                (Point.fromInts ( x, y1 - 1 ))
            , line
                (Point.fromInts ( x1, y1 ))
                (Point.fromInts ( x, y1 ))
            , line
                (Point.fromInts ( x1, y1 ))
                (Point.fromInts ( x1, y ))
            ]


type alias Pixel =
    List Int


type alias Row =
    List Pixel


--scale : Float -> Float -> Size -> List Int -> List Int
--scale xFactor yFactor {width, height} data =
scale : Size -> Size -> List Int -> List Int
scale oldSize newSize data =
    let
        xOccurances =
            getOccurances
                ((toFloat newSize.width) / (toFloat oldSize.width))
                oldSize.width

        yOccurances =
            getOccurances
                ((toFloat newSize.height) / (toFloat oldSize.height))
                oldSize.height
    in
        getScaledData 
            xOccurances 
            yOccurances 
            (getRows data oldSize)


getScaledData : List Int -> List Int -> List Row -> List Int
getScaledData xOccurances yOccurances rows =
    List.map (List.map2 scaleHelp xOccurances) rows
        |> List.map2 scaleHelp yOccurances
        |> List.concat
        |> List.concat


scaleHelp : Int -> List a -> List a
scaleHelp n l =
    List.concat (List.repeat n l)


getOccurances : Float -> Int -> List Int
getOccurances factor length =
    List.range 0 length
        |> List.map (toFloat >> (*) factor >> floor)
        |> pairWithNext
        |> List.map calcOccurance


pairWithNext : List Int -> List (Int, Int)
pairWithNext l =
    List.map2 (,) l (List.drop 1 l)


calcOccurance : (Int, Int) -> Int
calcOccurance (i, j) =
    j - i


getRows : List Int -> Size ->List Row
getRows data { width, height } =
    data
        |> intoPixels []
        |> intoRowsLoop width []


intoRowsLoop : Int -> List Row -> List Pixel -> List Row
intoRowsLoop width rows pixels =
    if List.length pixels <= width then
        pixels :: rows
    else
        intoRowsLoop
            width
            (List.take width pixels :: rows)
            (List.drop width pixels)


intoPixels : List Pixel -> List Int -> List Pixel
intoPixels pixels data =
    if List.length data <= 4 then
        data :: pixels
    else
        intoPixels
            (List.take 4 data :: pixels)
            (List.drop 4 data)


{-|
    Bezier
-}
bezier : Int -> Point -> Point -> Point -> Point -> List Point
bezier resolution p0 p1 p2 p3 =
    let
        points =
            bezierLoop
                resolution
                0
                (Point.toFloats p0)
                (Point.toFloats p1)
                (Point.toFloats p2)
                (Point.toFloats p3)
                []
    in
        List.map2 (,) points (List.drop 1 points)
            |> List.map applyLine
            |> List.concat


applyLine : ( Point, Point ) -> List Point
applyLine ( p0, p1 ) =
    line p0 p1


bezierLoop : Int -> Int -> ( Float, Float ) -> ( Float, Float ) -> ( Float, Float ) -> ( Float, Float ) -> List Point -> List Point
bezierLoop seg i p0 p1 p2 p3 points =
    let
        points_ =
            (calcBezierPoint seg i p0 p1 p2 p3) :: points
    in
        if i < seg then
            bezierLoop seg (i + 1) p0 p1 p2 p3 points_
        else
            points_


calcBezierPoint : Int -> Int -> ( Float, Float ) -> ( Float, Float ) -> ( Float, Float ) -> ( Float, Float ) -> Point
calcBezierPoint seg i ( p0x, p0y ) ( p1x, p1y ) ( p2x, p2y ) ( p3x, p3y ) =
    let
        ( a, b, c, d ) =
            calcBezier seg i
    in
        Point.fromFloats
            ( a * p0x + b * p1x + c * p2x + d * p3x
            , a * p0y + b * p1y + c * p2y + d * p3y
            )


calcBezier : Int -> Int -> ( Float, Float, Float, Float )
calcBezier seg i =
    let
        a =
            (toFloat i) / (toFloat seg)

        b =
            1 - a
    in
        ( b ^ 3
        , 3 * b ^ 2 * a
        , 3 * a ^ 2 * b
        , a ^ 3
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


line : Point -> Point -> List Point
line p q =
    let
        ( px, py ) =
            Point.toInts p

        ( qx, qy ) =
            Point.toInts q

        ( statics, error ) =
            lineInit qx qy px py
    in
        lineLoop statics error ( px, py ) []
            |> List.map Point.fromInts


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
