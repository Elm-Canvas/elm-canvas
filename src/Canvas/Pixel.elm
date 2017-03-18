module Canvas.Pixel
    exposing
        ( put
        , get
        , line
        , rectangle
        , bezier
        , ellipse
        , circle
        )

{-| The basic methods of the canvas element do not lend themselves well to pixel perfect canvas drawing. This module exposes a number of functions which make doing so easy. By pixel perfect, we mean, drawing with no anti-aliased edges.

# Basics
@docs put, get

# Point Calculation
@docs line, rectangle, bezier, circle, ellipse
-}

import Canvas exposing (Canvas, Size, DrawOp(..))
import Canvas.Point exposing (Point)
import Canvas.Point as Point
import Color exposing (Color)
import Array exposing (Array)


{-| Give `put` a `Color`, and a `Point`, and you have a `DrawOp` which will set that exact pixel to that exact color.

    putRedPixel : Point -> Canvas -> Canvas
    putRedPixel point =
        Canvas.batch
            [ Pixel.put Color.red point ]

-}
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
toColor colorValues =
    let
        rgba =
            Array.fromList colorValues
    in
        Color.rgba
            (toColorHelp 0 rgba)
            (toColorHelp 1 rgba)
            (toColorHelp 2 rgba)
            (((toColorHelp 3 rgba) |> toFloat) / 255)


toColorHelp : Int -> Array Int -> Int
toColorHelp index colorValues =
    Array.get index colorValues |> Maybe.withDefault 0


{-| Also as fundamental to `put`, `get` will give you the color value of a specific pixel in a `Canvas`.

    isBlueAt : Point -> Canvas -> Bool
    isBlueAt point canvas =
        (Pixel.get point canvas) == Color.blue
-}
get : Point -> Canvas -> Color
get point canvas =
    Canvas.getImageData
        point
        (Size 1 1)
        canvas
        |> toColor


{-| To get a list of `Point` along the edge of a rectangle, use `Pixel.rectangle`.

    drawRectangle : Color -> Size -> Point -> Canvas -> Canvas
    drawRectangle color size point =
        Pixel.rectangle size point
            |> List.map (Pixel.put color)
            |> Canvas.batch
-}
rectangle : Size -> Point -> List Point
rectangle { width, height } point =
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


{-| To get a list of `Point` along the edge of a circle of diameter `Int`, use `Pixel.circle`.

    drawCircle : Color -> Int -> Point -> Canvas -> Canvas
    drawCircle color diameter point =
        Pixel.circle diameter point
            |> List.map (Pixel.put color)
            |> Canvas.batch
-}
circle : Int -> Point -> List Point
circle diameter =
    ellipse (Size diameter diameter)


{-| To get a list of `Point` along the edge of a ellipse of dimensions `Size`, use `Pixel.ellipse`.

    circle : Int -> Point -> List Point
    circle diameter point =
        ellipse (Size diameter diameter) point
-}
ellipse : Size -> Point -> List Point
ellipse { width, height } point =
    let
        adjustedPoint =
            let
                ( x, y ) =
                    Point.toInts point
            in
                Point.fromInts
                    ( x + width
                    , y + height
                    )

        firstHalf =
            ellipseLoopFirst
                (Point.toInts adjustedPoint)
                ( 0, height )
                (2 * (width ^ 2) + (height ^ 2) * (1 - 2 * height))
                (Size width height)
                []

        secondHalf =
            ellipseLoopSecond
                (Point.toInts adjustedPoint)
                ( width, 0 )
                (2 * (width ^ 2) + (height ^ 2) * (1 - 2 * width))
                (Size width height)
                []
    in
        List.map Point.fromInts (List.append firstHalf secondHalf)


ellipseLoopFirst : ( Int, Int ) -> ( Int, Int ) -> Int -> Size -> List ( Int, Int ) -> List ( Int, Int )
ellipseLoopFirst ( cx, cy ) ( x, y ) sigma { width, height } points =
    if x * (height ^ 2) <= y * (width ^ 2) then
        let
            ( dy, dSigma ) =
                if sigma >= 0 then
                    ( 1, (4 * (width ^ 2)) * (1 - y) )
                else
                    ( 0, 0 )
        in
            ellipseLoopFirst
                ( cx, cy )
                ( x + 1, (y - dy) )
                (sigma + dSigma + ((height ^ 2) * ((4 * x) + 6)))
                (Size width height)
                (addPoints cx cy x y points)
    else
        points


ellipseLoopSecond : ( Int, Int ) -> ( Int, Int ) -> Int -> Size -> List ( Int, Int ) -> List ( Int, Int )
ellipseLoopSecond ( cx, cy ) ( x, y ) sigma { width, height } points =
    if y * (width ^ 2) <= x * (height ^ 2) then
        let
            ( dx, dSigma ) =
                if sigma >= 0 then
                    ( 1, (4 * (height ^ 2)) * (1 - x) )
                else
                    ( 0, 0 )
        in
            ellipseLoopSecond
                ( cx, cy )
                ( x - dx, y + 1 )
                (sigma + dSigma + ((width ^ 2) * ((4 * y) + 6)))
                (Size width height)
                (addPoints cx cy x y points)
    else
        points


addPoints : Int -> Int -> Int -> Int -> List ( Int, Int ) -> List ( Int, Int )
addPoints cx cy x y points =
    List.append
        points
        [ ( cx + x, cy + y )
        , ( cx - x, cy + y )
        , ( cx + x, cy - y )
        , ( cx - x, cy - y )
        ]


{-| To make a curved line, try this function called `bezier`, named after [the bezier curve](https://en.wikipedia.org/wiki/B%C3%A9zier_curve). It works by approximation, drawing many small straight lines along a curved path. Its first parameter, an `Int`, is the resolution of the curve (resolution=1 will be just a straight line, and higher values will compute a more perfect curve). The remaining parameters are `Point`. The first and last `Point` refer to the starting and ending points of the curve. The middle two are control points, which are where the curve will curve towards from each end point.

    drawArc : Color -> Point -> Point -> Int -> Canvas -> Canvas
    drawArc color starting ending height =
        let
            ( sx, sy ) =
                Point.toInts starting

            ( ex, ey ) =
                Point.toInts ending
        in
            Pixel.bezier
                (abs (sx - ex))
                starting
                (Point.fromInts (sx, sy + height))
                (Point.fromInts (ex, ey + height))
                ending
                |> List.map (Pixel.put color)
                |> Canvas.batch

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


{-| Given a starting and ending `Point`, this function will give you every `Point` along that line. It uses the bresenham line algorithm.

    drawLine : Color -> Point -> Point -> Canvas -> Canvas
    drawLine color starting ending =
        Pixel.line starting ending
            |> List.map (Pixel.put color)
            |> Canvas.batch
-}
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
