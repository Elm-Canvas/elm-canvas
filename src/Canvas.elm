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


type alias ImageData =
  { width  : Int
  , height : Int
  , data   : Array Int
  }


type alias Position = 
  { x : Int, y : Int }

origin = Position 0 0

type alias Pixel = 
  { color    : Color
  , position : Position
  }



blank : Int -> Int -> Color -> ImageData
blank width height color =
  let {red, green, blue, alpha} = toRgb color in
  [ red, green, blue, round (alpha * 255) ]
  |>List.repeat (width * height)
  |>List.concat
  |>Array.fromList
  |>ImageData width height 


-- get


get : String -> Maybe (ImageData)
get id = 
  Native.Canvas.get id


cropGet : Position -> Int -> Int -> String -> Maybe (ImageData)
cropGet origin width height id =
  Native.Canvas.cropGet id origin width height 


-- put 


put : ImageData -> Position -> String -> Maybe (ImageData)
put imageData position id =
  Native.Canvas.put imageData position id


-- setPixel


setPixel : String -> Pixel -> Maybe (ImageData)
setPixel id pixel =
  Native.Canvas.setPixel pixel id 


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



-- Html Attributes


size : (Int, Int) -> Attribute a
size (width, height) =
  style 
  [ ("width", toString width)
  , ("height", toString height)
  ]



-- toHtml


toHtml : String -> ImageData -> List (Attribute msg) -> Html msg
toHtml id_ imageData attr =
  Native.Canvas.canvas
  (List.concat [ attr, [ id id_ ] ])
  imageData.width
  imageData.height
  imageData.data




