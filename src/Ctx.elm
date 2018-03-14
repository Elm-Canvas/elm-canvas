module Ctx
    exposing
        ( Ctx
        , DrawImageParams(..)
        , Repeat(..)
        , Style(..)
        , arc
        , arcTo
        , batch
        , beginPath
        , bezierCurveTo
        , clearRect
        , clip
        , closePath
        , draw
        , drawImage
        , fill
        , fillRect
        , fillStyle
        , fillText
        , font
        , globalAlpha
        , globalCompositionOp
        , lineCap
        , lineDashOffset
        , lineJoin
        , lineTo
        , lineWidth
        , miterLimit
        , moveTo
        , none
        , putImageData
        , quadraticCurveTo
        , rect
        , rotate
        , scale
        , setLineDash
        , setTransform
        , shadowBlur
        , shadowColor
        , shadowOffsetX
        , stroke
        , strokeRect
        , strokeStyle
        , strokeText
        , textAlign
        , textBaseline
        , transform
        )

{-| These are all the methods of the `ctx` api, that you get from `canvas.getContext('2d'). You can get a look at them al [here](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D). These`Ctx`properties and methods can be grouped together with`batch`and then applied to a`Canvas`using`Canvas.draw` in the Canvas module. For example, you could draw a line like this..

    drawLine : Point -> Point -> Canvas -> Canvas
    drawLine p0 p1 canvas =
        [ Ctx.beginPath
        , Ctx.lineWidth 2
        , Ctx.moveTo p0
        , Ctx.lineTo p1
        , Ctx.stroke
        ]
            |> Ctx.draw canvas

..or invert the color of a canvas like this

    invert : Canvas -> Canvas
    invert canvas =
        [ Ctx.globalCompositionOp "difference"
        , Ctx.fillStyle Color.white
        , Ctx.fillRect
            { x = 0, y = 0 }
            (Canvas.getSize canvas)
        ]
            |> Ctx.draw canvas


# Draw

@docs draw, batch, none


# Ctx

@docs Ctx, arc, arcTo, Ctx, batch, beginPath, bezierCurveTo, clearRect, clip, closePath, drawImage, fill, fillRect, fillStyle, fillText, font, globalAlpha, globalCompositionOp, lineCap, lineDashOffset, lineJoin, lineTo, lineWidth, miterLimit, moveTo, none, putImageData, quadraticCurveTo, rect, rotate, scale, setLineDash, setTransform, shadowBlur, shadowColor, shadowOffsetX, stroke, strokeRect, strokeStyle, strokeText, textAlign, textBaseline, transform, draw

-}

import Canvas exposing (Canvas, Point, Size)
import Color exposing (Color, Gradient)
import Native.Canvas


{-| This is our primary way of drawing onto canvases. Give `draw` a `drawOp` and apply it to a canvas.

    drawLine : Point -> Point -> Canvas -> Canvas
    drawLine p0 p1 canvas =
        [ Ctx.beginPath
        , Ctx.lineWidth 2
        , Ctx.moveTo p0
        , Ctx.lineTo p1
        , Ctx.stroke
        ]
            |> Ctx.draw canvas

-}
draw : Canvas -> List Ctx -> Canvas
draw canvas ctxs =
    Native.Canvas.draw canvas (batch ctxs)


{-| -}
font : String -> Ctx
font =
    Font


{-| -}
arc : Point -> Float -> Float -> Float -> Ctx
arc =
    Arc


{-| -}
arcTo : Point -> Point -> Float -> Ctx
arcTo =
    ArcTo


{-| -}
strokeText : String -> Point -> Ctx
strokeText =
    StrokeText


{-| -}
fillText : String -> Point -> Ctx
fillText =
    FillText


{-| -}
globalAlpha : Float -> Ctx
globalAlpha =
    GlobalAlpha


{-| -}
globalCompositionOp : String -> Ctx
globalCompositionOp =
    GlobalCompositionOp


{-| -}
lineCap : String -> Ctx
lineCap =
    LineCap


{-| -}
lineDashOffset : Float -> Ctx
lineDashOffset =
    LineDashOffset


{-| -}
lineWidth : Float -> Ctx
lineWidth =
    LineWidth


{-| -}
miterLimit : Float -> Ctx
miterLimit =
    MiterLimit


{-| -}
lineJoin : String -> Ctx
lineJoin =
    LineJoin


{-| -}
lineTo : Point -> Ctx
lineTo =
    LineTo


{-| -}
moveTo : Point -> Ctx
moveTo =
    MoveTo


{-| -}
shadowBlur : Float -> Ctx
shadowBlur =
    ShadowBlur


{-| -}
shadowColor : Color -> Ctx
shadowColor =
    ShadowColor


{-| -}
shadowOffsetX : Float -> Ctx
shadowOffsetX =
    ShadowOffsetX


{-| -}
shadowOffsetY : Float -> Ctx
shadowOffsetY =
    ShadowOffsetY


{-| -}
stroke : Ctx
stroke =
    Stroke


{-| -}
fill : Ctx
fill =
    Fill


{-| -}
fillRect : Point -> Size -> Ctx
fillRect =
    FillRect


{-| -}
rect : Point -> Size -> Ctx
rect =
    Rect


{-| -}
rotate : Float -> Ctx
rotate =
    Rotate


{-| -}
scale : Float -> Float -> Ctx
scale =
    Scale


{-| -}
setLineDash : List Int -> Ctx
setLineDash =
    SetLineDash


{-| -}
setTransform : Float -> Float -> Float -> Float -> Float -> Float -> Ctx
setTransform =
    SetTransform


{-| -}
transform : Float -> Float -> Float -> Float -> Float -> Float -> Ctx
transform =
    Transform


{-| -}
translate : Point -> Ctx
translate =
    Translate


{-| -}
strokeRect : Point -> Size -> Ctx
strokeRect =
    StrokeRect


{-| -}
strokeStyle : Style -> Ctx
strokeStyle =
    StrokeStyle


{-| -}
textAlign : String -> Ctx
textAlign =
    TextAlign


{-| -}
textBaseline : String -> Ctx
textBaseline =
    TextBaseline


{-| -}
fillStyle : Style -> Ctx
fillStyle =
    FillStyle


{-| -}
beginPath : Ctx
beginPath =
    BeginPath


{-| -}
bezierCurveTo : Point -> Point -> Point -> Ctx
bezierCurveTo =
    BezierCurveTo


{-| -}
quadraticCurveTo : Point -> Point -> Ctx
quadraticCurveTo =
    QuadraticCurveTo


{-| -}
putImageData : List Int -> Size -> Point -> Ctx
putImageData =
    PutImageData


{-| -}
clearRect : Point -> Size -> Ctx
clearRect =
    ClearRect


{-| -}
clip : Ctx
clip =
    Clip


{-| -}
closePath : Ctx
closePath =
    ClosePath


{-| -}
drawImage : Canvas -> DrawImageParams -> Ctx
drawImage =
    DrawImage


{-| You dont want to apply `DrawOp` one at a time, its inefficient. Bundle many `DrawOp` together in one batch, using `batch`.

    line : Point -> Point -> DrawOp
    line p0 p1 =
        [ Ctx.beginPath
        , Ctx.lineWidth 2
        , Ctx.moveTo p0
        , Ctx.lineTo p1
        , Ctx.stroke
        ]
            |> Ctx.batch

-}
batch : List Ctx -> Ctx
batch =
    Batch


{-| Short for `batch []`. This is useful when you need to keep a `Ctx` somewhere, like in your model, but want to include the possibility of doing nothing.
-}
none : Ctx
none =
    Batch []


type Ctx
    = Font String
    | Arc Point Float Float Float
    | ArcTo Point Point Float
    | StrokeText String Point
    | FillText String Point
    | GlobalAlpha Float
    | GlobalCompositionOp String
    | LineCap String
    | LineDashOffset Float
    | LineWidth Float
    | MiterLimit Float
    | LineJoin String
    | LineTo Point
    | MoveTo Point
    | ShadowBlur Float
    | ShadowColor Color
    | ShadowOffsetX Float
    | ShadowOffsetY Float
    | Stroke
    | Fill
    | FillRect Point Size
    | Rect Point Size
    | Rotate Float
    | Scale Float Float
    | SetLineDash (List Int)
    | SetTransform Float Float Float Float Float Float
    | Transform Float Float Float Float Float Float
    | Translate Point
    | StrokeRect Point Size
    | StrokeStyle Style
    | TextAlign String
    | TextBaseline String
    | FillStyle Style
    | BeginPath
    | BezierCurveTo Point Point Point
    | QuadraticCurveTo Point Point
    | PutImageData (List Int) Size Point
    | ClearRect Point Size
    | Clip
    | ClosePath
    | DrawImage Canvas DrawImageParams
    | Batch (List Ctx)


{-| `Style` specifies the style to apply as a `FillStyle` or a `StrokeStyle`.
-}
type Style
    = Color Color
    | Pattern Canvas Repeat
    | Gradient Gradient


{-| Specifies the axis/axes along which to replicate a pattern. For use with the `Pattern` `Style`.
-}
type Repeat
    = Repeat
    | RepeatX
    | RepeatY
    | NoRepeat


{-| The `DrawOp` `DrawImage` takes a `Canvas` and a `DrawImageParam`. We made three different `DrawImageParam`, because there are three different sets of parameters you can give the native javascript `ctx.drawImage()`. [See here for more info](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/drawImage.)
-}
type DrawImageParams
    = At Point
    | Scaled Point Size
    | CropScaled Point Size Point Size
