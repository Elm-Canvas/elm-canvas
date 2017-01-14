module Canvas exposing (..)


import Html exposing (Html, Attribute)
import Html.Events exposing (on)
import Color exposing (Color)
import List
import Array exposing (Array)
import Json.Decode as Json
import Color exposing (Color)
import Task exposing (Task)
import Native.Canvas


{-| The canvas html element is a very simple way to render 2D graphics. [Check out these examples, and get an explanation of the canvas element here](https://github.com/elm-community/canvas). Furthermore, If you havent heard of [Elm-Graphics](http://package.elm-lang.org/packages/evancz/elm-graphics/latest), I recommend checking that out first. Elm-Graphics is probably what you need. Elm-Canvas is for when you need direct and low level access to the canvas element.)

# Main Types
@docs Canvas, Image, Position, Error

# Simple Stuff
@docs initialize, fill, toHtml

# Drawing
@docs drawCanvas, drawImage, setPixel, setPixels, drawLine, drawRectangle

-}

-- TYPES

{-| A `Canvas` contains image data, and can be render as html with `toHtml`. There are a number of graphics operations in this package, they all operate on `Canvas`s. 
-}
type Canvas
  = Canvas

{-| Images loaded in from a url come in type `Image`. `Image`s cant be rendered like `Canvas` can, but they can be drawn onto a `Canvas` using `drawImage`.
-}
type Image
  = Image

{-| Sometimes loading an `Image` from a url wont work. When it doesnt, youll get an `Error` instead.
-}
type Error 
  = Error

{-| A `Position` contains x and y coordinates. Many functions will take a `Position` to indicate where a rendering operation should occur on a canvas. This type alias is identical to the one found in `elm-lang/mouse`.
-}
type alias Position = 
  { x : Int, y : Int }


{-| `initialize` takes in a width and a height (both type `Int), and returns a `Canvas` with that width and height. A freshly initialized `Canvas` is entirely transparent (its data is an array of 0s, that has a length of width * height * 4)

    squareCanvas : Int -> Canvas
    squareCanvas length =
      initialize length length
-}
initialize : Int -> Int -> Canvas
initialize width height =
  Native.Canvas.initialize width height


{-| `fill` takes a canvas and gives you one with the same dimensions, except entirely solid in its color. Giving `fill` the color blue and a canvas 400 x 300 pixels in dimensions will return a blue square 400 x 300 pixels.

    blueSquare : Int -> Canvas
    blueSuqare length =
      initialize length length
      |>fill Color.blue
-}
fill : Color -> Canvas -> Canvas
fill = 
  Native.Canvas.fill 


-- getSize


getImageSize : Image -> (Int, Int)
getImageSize =
  Native.Canvas.getSize


getCanvasSize : Canvas -> (Int, Int)
getCanvasSize =
  Native.Canvas.getSize


{-|`drawCanvas` takes a `Canvas`, and draws into onto another `Canvas` at a `Position`.

    div []
    [ p [] [ text "Sword Fighter II" ]
    , drawCanvas
        player.sprite
        player.position
        environment
      |>toHtml []
    ]
-}
drawCanvas : Canvas -> Position -> Canvas -> Canvas
drawCanvas =
  Native.Canvas.drawCanvas


-- loadImage

loadImage : String -> Task Error Image
loadImage =
  Native.Canvas.loadImage


{-|Just like `drawCanvas` except it draws an `Image`. 
-}
drawImage : Image -> Position -> Canvas -> Canvas
drawImage =
  Native.Canvas.drawImage


-- getImageData

{-|`Canvas`s have image data. Image data is an array of integers all between 0 and 255. They represent the RGBA values of every pixel in the image, where the first four `Int`s are the first pixel, the next four `Int`s the second pixels, etc.

    -- twoByTwoCanvas =
    --         |
    --   Black | Red
    --         |
    --  ---------------
    --         |
    --   Black | White
    --         |

    getImageData twoBytwoCanvas ==
      [ 0, 0, 0, 255,      255, 0, 0, 255
      , 0, 0, 0, 255,      255, 255, 255, 255
      ]
-}
getImageData : Canvas -> Array Int
getImageData =
  Native.Canvas.getImageData 


-- fromImageData

{-|Make a new `Canvas` with given dimensions and image data. 

    invertColors : Canvas -> Canvas
    invertColors canvas =
      let
        (width, height) =
          Canvas.getCanvasSize canvas
      in
      getImageData canvas
      |>Array.indexedMap invertHelp
      |>fromImageData width height

    invertHelp : Int -> Int -> Int 
    invertHelp index colorValue =
      if index % 4 == 3 then
        colorValue
      else
        255 - colorValue
-}
fromImageData : Int -> Int -> Array Int -> Canvas
fromImageData =
  Native.Canvas.fromImageData


-- setPixel

{-|set the pixel at a specific position to a specific color in a given canvas.
    
    setUpperLeftCornerBlue : Canvas -> Canvas
    setUpperLeftCornerBlue =
      setPixel Color.blue (Position 0 0)
-}
setPixel : Color -> Position -> Canvas -> Canvas
setPixel =
  Native.Canvas.setPixel 


{-|A more performant way to set many pixels. 

    drawRedCircle : Position -> Int -> Canvas -> Canvas
    drawCirlce center radius =
      calculateCircle center radius
      |>List.map ((,) Color.red)
      |>setPixels
-}
setPixels : List (Color, Position) -> Canvas -> Canvas
setPixels =
  Native.Canvas.setPixels


-- drawLine

{-|Takes a starting and ending `Position`, a `Color`, and draws a line from the start to the finish in that color. It uses the bresenham line algorithm to compute the pixels in the line.
-}
drawLine : Position -> Position -> Color -> Canvas -> Canvas
drawLine p0 p1 color =
  let
    pixels =
      List.map 
        ((,) color) 
        (line p0 p1)
  in
    Native.Canvas.setPixels pixels


-- drawRect

{-|Draws a rectangle from the upper left `Position`, with a width and a height (both `Int`s).

    drawSquare : Position -> Int -> Color -> Canvas -> Canvas
    drawSquare position length =
      drawRectangle position length length
-}
drawRectangle : Position -> Int -> Int -> Color -> Canvas -> Canvas
drawRectangle {x, y} width height color =
  let
    pixels =
      let 
        x1 = x + width
        y1 = y + height
      in
      List.map ((,) color)
      <|List.concat
        [ line (Position x y) (Position (x1 - 1) y) 
        , line (Position x y) (Position x (y1 - 1))
        , line (Position x1 y1) (Position x y1)
        , line (Position x1 y1) (Position x1 y)
        ]
  in
    Native.Canvas.setPixels pixels

-- crop


crop : Position -> Int -> Int -> Canvas -> Canvas
crop position width height canvas =
  Native.Canvas.crop position width height canvas


-- Html Events


onMouseDown : (Position -> msg) -> Attribute msg
onMouseDown message =
  on "mousedown" <| Json.map (positionInCanvas >> message) positionDecoder

onMouseUp : (Position -> msg) -> Attribute msg
onMouseUp message =
  on "mouseup" <| Json.map (positionInCanvas >> message) positionDecoder

onMouseMove : (Position -> msg) -> Attribute msg
onMouseMove message =
  on "mousemove" <| Json.map (positionInCanvas >> message) positionDecoder

positionInCanvas : (Position, Position) -> Position
positionInCanvas (client, offset) =
  Position (client.x - offset.x) (client.y - offset.y)


positionDecoder : Json.Decoder (Position, Position)
positionDecoder = 
  Json.at ["target"] (toPosition "offsetLeft" "offsetTop")
  |>Json.map2 (,) (toPosition "clientX" "clientY")

toPosition : String -> String -> Json.Decoder Position
toPosition x y =
  Json.map2 Position (field_ x) (field_ y)

field_ : String -> Json.Decoder Int
field_ key =
  Json.field key Json.int


{-|To turn a `Canvas` into `Html msg`, run it through `toHtml`. The first parameter of `toHtml` is a list of attributes just like node in `elm-lang/html`. 

    pixelatedRender : Canvas -> Html Msg
    pixelatedRender canvas =
      toHtml 
        [ style
          [ ("image-rendering", "pixelated") ]
        ]
        canvas
-}


toHtml : List (Attribute msg) -> Canvas -> Html msg
toHtml =
  Native.Canvas.toHtml


-- Brensenham Line Algorithm


type alias BresenhamStatics = 
  { finish : Position, sx : Int, sy : Int, dx : Float, dy : Float }


line : Position -> Position -> List Position
line p q =
  let
    dx = (toFloat << abs) (q.x - p.x)
    sx = if p.x < q.x then 1 else -1
    dy = (toFloat << abs) (q.y - p.y)
    sy = if p.y < q.y then 1 else -1

    error =
      (if dx > dy then dx else -dy) / 2

    statics = 
      BresenhamStatics q sx sy dx dy 
  in
  bresenhamLineLoop statics error p []


bresenhamLineLoop : BresenhamStatics -> Float -> Position -> List Position -> List Position
bresenhamLineLoop statics error p positions =
  let 
    positions_ = p :: positions 
    {sx, sy, dx, dy, finish} = statics
  in
  if (p.x == finish.x) && (p.y == finish.y) then positions_
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






