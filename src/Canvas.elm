module Canvas exposing (..)


import Html exposing (Html, Attribute)
import Html.Attributes exposing (id, style)
import Html.Events exposing (on)
import Color exposing (Color)
import List
import Array exposing (Array)
import Native.Canvas
import Json.Decode as Json
import Color exposing (toRgb)
import Debug exposing (log)

-- TYPES


type alias Canvas =
  { id        : String
  , imageData : ImageData
  }


type alias ImageData =
  { width  : Int
  , height : Int
  , data   : Array Int
  }


type alias Position = 
  { x : Int, y : Int }


type alias Pixel = 
  { color    : Color
  , position : Position
  }


type alias Index = Int


blank : String -> Int -> Int -> Color -> Canvas
blank id width height color =
  let {red, green, blue, alpha} = toRgb color in
  [ red, green, blue, round (alpha * 255) ]
  |>List.repeat (width * height)
  |>List.concat
  |>Array.fromList
  |>ImageData width height 
  |>Canvas id


-- putImageData 


putImageData : ImageData -> Position -> Canvas -> Canvas
putImageData imageData position canvas =
  Native.Canvas.putImageData 
    imageData 
    position
    { canvas 
    | imageData =
      { imageData 
      | data = 
          Array.foldr 
            (putDatum (getIndex (4 * imageData.width) position)) 
            imageData.data
            (Array.indexedMap (,) imageData.data)
      }  
    }


putDatum : Int -> (Int, Int) -> Array Int -> Array Int
putDatum indexShift (index, datum) data =
  Array.set (index + indexShift) datum data



-- putPixels



putPixels : List Pixel -> Canvas -> Canvas
putPixels pixels {id, imageData} =
  { imageData 
  | data =
      pixels
      |>List.map (toData imageData.width)
      |>List.concat
      |>List.foldr insertDatum imageData.data
  }
  |>Canvas id
  |>Native.Canvas.putPixels pixels


toData : Int -> Pixel -> List (Index, Int)
toData width {color, position} =
  let
    i = getIndex width position

    {red, green, blue, alpha} =
      toRgb color
  in
  [ (i, red)
  , (i + 1, green)
  , (i + 2, blue)
  , (i + 3, round (alpha * 255))
  ]


insertDatum : (Index, Int) -> Array Int -> Array Int
insertDatum (index, datum) data =
  Array.set index datum data


getIndex : Int -> Position -> Int
getIndex width {x, y} = 
  (x + (width * y)) * 4


-- onMouseDown


onMouseDown : (Position -> msg) -> Attribute msg
onMouseDown message =
  on "mousedown" <| Json.map (positionInCanvas >> message) positionDecoder


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
canvas : List (Attribute msg) -> Int -> Int -> Array Int -> Html msg
canvas attr width height data =
  Native.Canvas.canvas attr width height data


toHtml : Canvas -> List (Attribute msg) -> Html msg
toHtml c attr =
  Native.Canvas.canvas
  (List.concat [ attr, [ id c.id ] ])
  c.imageData.width
  c.imageData.height
  c.imageData.data



