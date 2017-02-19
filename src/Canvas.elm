module Canvas
    exposing
        ( Canvas
        , Error
        , Point
        , Size
        , DrawOp(..)
        , DrawImageParams(..)
        , initialize
        , toHtml
        , batch
        , loadImage
        , getImageData
        , getSize
        , setSize
        )

{-| The canvas html element is a very simple way to render 2D graphics. Check out these examples, and get an explanation of the canvas element [here](https://github.com/elm-community/canvas). Furthermore, If you havent heard of [Elm-Graphics](http://package.elm-lang.org/packages/evancz/elm-graphics/latest), I recommend checking that out first, because its probably what you need. Elm-Canvas is for when you need unusually direct and low level access to the canvas element.

# Main Types
@docs Canvas, Point, Size

# Basics
@docs initialize, toHtml

-}

import Html exposing (Html, Attribute)
import Array exposing (Array)
import Task exposing (Task)
import Color exposing (Color)
import Native.Canvas


{-| A `Canvas` contains image data, and can be rendered as html with `toHtml`. There are many drawing functions in this package, and they all operate on `Canvas`.
-}
type Canvas
    = Canvas


{-| Sometimes loading an `Image` from a url wont work. When it doesnt, youll get an `Error` instead.
-}
type Error
    = Error


{-| A `Point` contains x and y coordinates. Many functions will take a `Point` to indicate where a drawing should occur on a `Canvas`.
-}
type alias Point =
    { x : Float, y : Float }


{-| A `Size` contains a width and a height`, both of which are `Int`. Many functions will take a `Size` to indicate the size of a canvas region. This type alias is identical to the one found in `elm-lang/window`.
-}
type alias Size =
    { width : Int, height : Int }


type DrawOp
    = Font String
    | StrokeText String Point
    | FillText String Point
    | GlobalAlpha Float
    | GlobalCompositionOp String
    | LineCap String
    | LineDashOffset Float
    | LineWidth Float
    | LineJoin String
    | LineTo Point
    | MoveTo Point
    | Stroke
    | Fill
    | Rect Point Size
    | StrokeRect Point Size
    | StrokeStyle Color
    | FillStyle Color
    | BeginPath
    | PutImageData (Array Int) Size Point
    | ClearRect Point Size
    | DrawImage Canvas DrawImageParams


type DrawImageParams
    = At Point
    | Scaled Point Size
    | CropScaled Point Size Point Size


{-| `initialize` takes in a width and a height (both type `Int`), and returns a `Canvas` with that width and height. A freshly initialized `Canvas` is entirely transparent (its data is an array of 0s, that has a length of width x height x 4)

    squareCanvas : Int -> Canvas
    squareCanvas length =
      initialize (Size length length)
-}
initialize : Size -> Canvas
initialize =
    Native.Canvas.initialize


{-| To turn a `Canvas` into `Html msg`, run it through `toHtml`. The first parameter of `toHtml` is a list of attributes just like node in `elm-lang/html`.

    pixelatedRender : Canvas -> Html Msg
    pixelatedRender canvas =
      toHtml [ class "pixelated" ] canvas
-}
toHtml : List (Attribute msg) -> Canvas -> Html msg
toHtml =
    Native.Canvas.toHtml


batch : List DrawOp -> Canvas -> Canvas
batch =
    Native.Canvas.batch


{-| Load up an `Image` from a url.

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
loadImage : String -> Task Error Canvas
loadImage =
    Native.Canvas.loadImage


{-| `Canvas` have image data. Image data is an array of `Int`, all of which are between 0 and 255. They represent the RGBA values of every pixel in the image, where the first four `Int` are the color values of the first pixel, the next four `Int` the second pixels, etc.

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


{-| Get the `Size` of a `Canvas`.
-}
getSize : Canvas -> Size
getSize =
    Native.Canvas.getSize


{-| Set the `Size` of a `Canvas`
-}
setSize : Size -> Canvas -> Canvas
setSize =
    Native.Canvas.setSize


clone : Canvas -> Canvas
clone =
    Native.Canvas.clone
