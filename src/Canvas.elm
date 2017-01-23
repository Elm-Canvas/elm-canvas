module Canvas 
  exposing 
    ( Canvas
    , Image
    , Position
    , Size
    , Error
    , initialize
    , fill
    , toHtml
    , drawCanvas
    , drawImage
    , setPixel
    , setPixels
    , drawLine
    , drawRectangle
    , crop
    , getImageData
    , loadImage
    , fromImageData
    , fromImage
    , onMouseDown
    , onMouseUp
    , onMouseMove
    , onClick
    , onDoubleClick
    , getCanvasSize
    , getImageSize
    )

{-| The canvas html element is a very simple way to render 2D graphics. Check out these examples, and get an explanation of the canvas element [here](https://github.com/elm-community/canvas). Furthermore, If you havent heard of [Elm-Graphics](http://package.elm-lang.org/packages/evancz/elm-graphics/latest), I recommend checking that out first, because its probably what you need. Elm-Canvas is for when you need unusually direct and low level access to the canvas element.

# Main Types
@docs Canvas, Position, Size

# Basics
@docs initialize, fill, toHtml

# Image
@docs Image, loadImage, Error, fromImage

# Drawing
@docs drawCanvas, drawImage, setPixel, setPixels, drawLine, drawRectangle, crop

# Image Data
@docs getImageData, fromImageData

# Size
@docs getCanvasSize, getImageSize

# Html Helpers
@docs onMouseDown, onMouseUp, onMouseMove, onClick, onDoubleClick

-}

import Html exposing (Html, Attribute)
import Html.Events exposing (on)
import List
import Array exposing (Array)
import Json.Decode as Json
import Color exposing (Color)
import Task exposing (Task)
import Native.Canvas


{-| A `Canvas` contains image data, and can be rendered as html with `toHtml`. There are many drawing functions in this package, and they all operate on `Canvas`. 
-}
type Canvas
  = Canvas

{-| Images loaded in from a url come as type `Image`. `Image` cant be rendered to html like `Canvas` can, but they can be drawn onto a `Canvas` using `drawImage`.
-}
type Image
  = Image

{-| Sometimes loading an `Image` from a url wont work. When it doesnt, youll get an `Error` instead.
-}
type Error 
  = Error

{-| A `Position` contains x and y coordinates. Many functions will take a `Position` to indicate where a drawing should occur on a `Canvas`. This type alias is identical to the one found in `elm-lang/mouse`.
-}
type alias Position = 
  { x : Int, y : Int }


{-| A `Size` contains a width and a height`, both of which are `Int`. Many functions will take a `Size` to indicate the size of a canvas region. This type alias is identical to the one found in `elm-lang/window`.
  -}
type alias Size =
  { width : Int, height : Int }


{-| `initialize` takes in a width and a height (both type `Int`), and returns a `Canvas` with that width and height. A freshly initialized `Canvas` is entirely transparent (its data is an array of 0s, that has a length of width x height x 4)

    squareCanvas : Int -> Canvas
    squareCanvas length =
      initialize (Size length length)
-}
initialize : Size -> Canvas
initialize =
  Native.Canvas.initialize


{-| `fill` takes a `Canvas` and gives you a `Canvas` with the same dimensions, except filled in with a uniform color.

    blueSquare : Int -> Canvas
    blueSquare length =
      initialize length length
      |>fill Color.blue
-}
fill : Color -> Canvas -> Canvas
fill color = 
  Native.Canvas.fill (Color.toRgb color)


{-|Get the `Size` of an `Image`. 
-}
getImageSize : Image -> Size
getImageSize =
  Native.Canvas.getSize

{-|Get the `Size` of a `Canvas`.
-}
getCanvasSize : Canvas -> Size
getCanvasSize =
  Native.Canvas.getSize


{-|`drawCanvas` takes a `Canvas`, and draws into onto another `Canvas` at a `Position`.

    view : Model -> Html Msg
    view {player, environment} =
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

{-|Load up an `Image` from a url. 

    loadSteelix : Cmd Msg
    loadSteelix =
      Task.attempt ImageLoaded (loadImage "./steelix.png")

    update : Msg -> Model -> (Model, Cmd Msg)
    update message model =
      case message of
        ImageLoaded -> result of
          case Result.toMaybe result of
            Just image ->
              -- ..
            Nothing ->
              -- ..
        -- ..
-}
loadImage : String -> Task Error Image
loadImage =
  Native.Canvas.loadImage


{-|Just like `drawCanvas`, except it draws an `Image`. 
-}
drawImage : Image -> Position -> Canvas -> Canvas
drawImage =
  Native.Canvas.drawImage



{-|`Canvas` have image data. Image data is an array of `Int`, all of which are between 0 and 255. They represent the RGBA values of every pixel in the image, where the first four `Int` are the color values of the first pixel, the next four `Int` the second pixels, etc.

    -- twoByTwoCanvas =

    --         |
    --   Black | Red
    --         |
    --  ---------------
    --         |
    --   Black | White
    --         |

    getImageData twoBytwoCanvas == fromList
      [ 0, 0, 0, 255,      255, 0, 0, 255
      , 0, 0, 0, 255,      255, 255, 255, 255
      ]
-}
getImageData : Canvas -> Array Int
getImageData =
  Native.Canvas.getImageData 


{-|Make a new `Canvas` with given size and image data. 

    invertColors : Canvas -> Canvas
    invertColors canvas =
      let
        size =
          Canvas.getCanvasSize canvas
      in
        getImageData canvas
        |>Array.indexedMap invertHelp
        |>fromImageData size

    invertHelp : Int -> Int -> Int 
    invertHelp index colorValue =
      if index % 4 == 3 then
        colorValue
      else
        255 - colorValue
-}
fromImageData : Size -> Array Int -> Canvas
fromImageData =
  Native.Canvas.fromImageData


{-|Make a `Canvas` from an `Image`.
-}
fromImage : Image -> Canvas
fromImage image =
  let
    size =
      getImageSize image
  in
    initialize size
    |>drawImage image (Position 0 0)


{-|set the pixel at a specific position to a specific color in a given canvas.
    
    setUpperLeftCornerBlue : Canvas -> Canvas
    setUpperLeftCornerBlue =
      setPixel Color.blue (Position 0 0)
-}
setPixel : Color -> Position -> Canvas -> Canvas
setPixel color =
  Native.Canvas.setPixel (Color.toRgb color)


{-|A more performant way to set many pixels. 

    calculateCircle : Position -> Int -> List Position
    calculateCircle center radius =
      -- math stuff goes here

    drawRedCircle : Position -> Int -> Canvas -> Canvas
    drawRedCircle center radius =
      calculateCircle center radius
      |>List.map ((,) Color.red)
      |>setPixels
-}
setPixels : List (Color, Position) -> Canvas -> Canvas
setPixels pixels =
  Native.Canvas.setPixels (List.map setPixelsHelp pixels)


type alias ColorHelp =
  { red : Int
  , green : Int
  , blue : Int
  , alpha : Float
  }


setPixelsHelp : (Color, Position) -> (ColorHelp, Position)
setPixelsHelp (color, position) =
  ((Color.toRgb color), position)


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
    Native.Canvas.setPixels (List.map setPixelsHelp pixels)


{-|Draws a rectangle from the upper left `Position`, with `Size` dimensions.

    drawSquare : Position -> Int -> Color -> Canvas -> Canvas
    drawSquare position length =
      drawRectangle position (Size length length)
-}
drawRectangle : Position -> Size -> Color -> Canvas -> Canvas
drawRectangle {x, y} {width, height} color =
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
    Native.Canvas.setPixels (List.map setPixelsHelp pixels)

-- crop

{-|Cut out a rectangle from an input `Canvas`.

    cutOutUpperLeftQuadrant : Canvas -> Canvas
    cutOutUpperLeftQuadrant canvas =
      let
        {width, height} =
          getCanvasSize canvas

        size =
          Size
            (width // 2) 
            (height // 2)
      in
        crop (Position 0 0) size canvas
        
-}
crop : Position -> Size -> Canvas -> Canvas
crop position size canvas =
  Native.Canvas.crop position size canvas


{-|Just like the `onMouseDown` in `Html.Events`, but this one passes along a `Position` that is relative to the `Canvas`. So clicking right in the middle of a 200x200 `Canvas` will return a `Position` == `{x = 100, y = 100}`.

    case message of 
      CanvasClick position ->
        -- ..
-}
onMouseDown : (Position -> msg) -> Attribute msg
onMouseDown message =
  on "mousedown" <| Json.map (positionInCanvas >> message) positionDecoder


{-|-}
onMouseUp : (Position -> msg) -> Attribute msg
onMouseUp message =
  on "mouseup" <| Json.map (positionInCanvas >> message) positionDecoder

{-|-}
onMouseMove : (Position -> msg) -> Attribute msg
onMouseMove message =
  on "mousemove" <| Json.map (positionInCanvas >> message) positionDecoder


{-|-}
onClick : (Position -> msg) -> Attribute msg
onClick message =
  on "click" <| Json.map (positionInCanvas >> message) positionDecoder


{-|-}
onDoubleClick : (Position -> msg) -> Attribute msg
onDoubleClick message =
  on "dblclick" <| Json.map (positionInCanvas >> message) positionDecoder


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
      toHtml [ class "pixelated" ] canvas
-}
toHtml : List (Attribute msg) -> Canvas -> Html msg
toHtml =
  Native.Canvas.toHtml




-- Brensenham Line Algorithm


type alias BresenhamStatics = 
  { finish : Position
  , sx : Int
  , sy : Int
  , dx : Float
  , dy : Float 
  }


line : Position -> Position -> List Position
line p q =
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






