module Canvas exposing (..)


import Html exposing (Html, Attribute)
import Html.Attributes exposing (id, style)
import Color exposing (Color)
import Task exposing (Task)
import List
import Native.Canvas


type alias Canvas =
  { id        : String
  , imageData : ImageData
  }

type alias ImageData =
  { width  : Int
  , height : Int
  , data   : List Int
  }

type alias Position = 
  { x : Int, y : Int }

type alias Pixel      = 
  { color    : Color
  , position : Position
  }


--fromPixels : List Pixel -> ImageData
--fromPixels pixels =


type Error 
  = CanvasDoesNotExist 

--type Msg
--  = SetPixels (List Pixel)


--update : Msg -> Canvas -> (Canvas, Cmd Msg)
--update msg c =
--  case msg of
--    SetPixels pixels ->
--      let
--        cmd = 
--          setPixels c.id pixels
--          |>attempt
--      in


putPixels : Canvas -> List Pixel -> Canvas
putPixels =
  Native.Canvas.putPixels








---------------
-- setPixels --
---------------
-- a function that dictates color changes
-- to specific pixel coordinates on a
-- specific canvas

-- PARAMETER canvasID
-- Which canvas element should be modified

-- PARAMETER pixels
-- A list of pixels, as in, a list of colors and
-- coordinates paired together, with the intention
-- that the coordinates become those colors
setPixels : String -> List Pixel -> Task Error ()
setPixels canvasId pixels =
  Native.Canvas.setPixels canvasId pixels


toHtml : Canvas -> List (Attribute msg) -> Html msg
toHtml c attr =
  Native.Canvas.canvas
  (List.concat [ attr, [ id c.id ] ])
  c.imageData.width
  c.imageData.height
  c.imageData.data

--toHtml : String -> ImageData -> Html msg
--toHtml id_ imageData =
--  Native.Canvas.canvas
--  [ id id_ 
--  , style
--    [ ("width", (toString imageData.width)) 
--    , ("height", (toString imageData.height))
--    ]
--  ]
--  imageData.width
--  imageData.height
--  imageData.data

------------
-- canvas --
------------
-- Simple function that returns a canvas with input
-- canvas data

-- PARAMETER attr
-- The attributes of the html element

-- PARAMETER width
-- Used to set the width of the canvas element
-- and used to set the width of the canvas data

-- PARAMETER height
-- Used to set the height of the canvas element
-- and used to set the height of the canvas data

-- PARAMETER data
-- A list of the canvas data. Its length must be width * height * 4
-- and the form is [ r0, g0, b0, a0, r1, g1, b1, a1, .. ], where
-- r1 is the red value for upper left most pixel.
canvas : List (Attribute msg) -> Int -> Int -> List Int -> Html msg
canvas attr width height data =
  Native.Canvas.canvas attr width height data






