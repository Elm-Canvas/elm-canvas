module Canvas
    exposing
        ( Canvas
        , Error
        , Point
        , Size
        , getImageData
        , getSize
        , initialize
        , loadImage
        , setSize
        , toDataUrl
        , toHtml
        )

{-| The canvas html element is a very simple way to render 2D graphics. Check out the examples in the Elm-Canvas github repo, and get an explanation of the canvas element [here](https://github.com/elm-community/canvas). Furthermore, If you havent heard of [Elm-Graphics](http://package.elm-lang.org/packages/evancz/elm-graphics/latest), I recommend checking that out first, because its probably what you need. Elm-Canvas is for when you need unusually direct and low level access to the canvas element.


# Main Types

@docs Canvas, Point, Size


# Basics

@docs initialize, toHtml


# Loading Images

@docs loadImage, Error


# Image Data

@docs getImageData, toDataUrl


# Sizing

@docs getSize, setSize

-}

import Html exposing (Attribute, Html)
import Native.Canvas
import Task exposing (Task)


{-| A `Canvas` contains image data, and can be rendered as html with `toHtml`. It is the primary type of this package.
-}
type Canvas
    = Canvas


{-| Sometimes loading a `Canvas` from a url wont work. When it doesnt, youll get an `Error` instead.
-}
type Error
    = Error


{-| A `Size` contains a width and a height, both of which are `Int`. Many functions will take a `Size` to indicate the size of a canvas region. This type alias is identical to the one found in `elm-lang/window`.
-}
type alias Size =
    { width : Int, height : Int }


{-| -}
type alias Point =
    { x : Float, y : Float }


{-| `initialize` takes `Size`, and returns a `Canvas` of that size. A freshly initialized `Canvas` is entirely transparent, meaning if you used `getImageData` to get its image data, it would be a `List Int` entirely of 0s.

    squareCanvas : Int -> Canvas
    squareCanvas length =
        initialize (Size length length)

-}
initialize : Size -> Canvas
initialize =
    Native.Canvas.initialize


{-| To turn a `Canvas` into `Html msg`, run it through `toHtml`. The first parameter of `toHtml` is a list of attributes just like the html nodes in `elm-lang/html`.

    pixelatedRender : Canvas -> Html Msg
    pixelatedRender canvas =
        canvas |> toHtml [ class "pixelated" ]

-}
toHtml : List (Attribute msg) -> Canvas -> Html msg
toHtml =
    Native.Canvas.toHtml


{-| Load up an image as a `Canvas` from a url.

    loadSteelix : Cmd Msg
    loadSteelix =
        Task.attempt ImageLoaded (loadImage "./steelix.png")

    update : Msg -> Model -> ( Model, Cmd Msg )
    update msg model =
        case msg of
            ImageLoaded (Ok canvas) ->
                -- ..

            ImageLoaded (Err Error) ->
                -- ..
        -- ..

-}
loadImage : String -> Task Error Canvas
loadImage =
    Native.Canvas.loadImage


{-| `Canvas` have data. Its data comes in the form `List Int`, all of which are between 0 and 255. They represent the RGBA values of every pixel in the image, where the first four `Int` are the color values of the first pixel, the next four `Int` the second pixels, etc. The length of the image data is always a multiple of four, since each pixel is represented by four `Int`.

    -- twoByTwoCanvas =

    --         |
    --   Black | Red
    --         |
    --  ---------------
    --         |
    --   Black | White
    --         |

    getImageData (Point 0 0) (Size 2 2) twoBytwoCanvas ==
        [ 0, 0, 0, 255,      255, 0, 0, 255
        , 0, 0, 0, 255,      255, 255, 255, 255
        ]

-}
getImageData : Point -> Size -> Canvas -> List Int
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


{-| Given a `String` mimetype, a `Float` quality, and a source `Canvas`, return a base64 encoded string of that data.
-}
toDataUrl : String -> Float -> Canvas -> String
toDataUrl =
    Native.Canvas.toDataURL
