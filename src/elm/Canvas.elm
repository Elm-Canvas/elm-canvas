module Canvas exposing (..)

import Html exposing (Html, Attribute)
import Task exposing (Task)
import Native.Canvas


type alias Coordinate = (Int, Int)
type alias Color      = (Int, Int, Int, Int)
type alias Pixel      = (Coordinate, Color)

type Error 
  = CanvasDoesNotExist 

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





