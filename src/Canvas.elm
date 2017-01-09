module Canvas exposing (..)


import Html exposing (Html, Attribute)
import Html.Attributes exposing (id, style)
import Html.Events exposing (on)
import Color exposing (Color)
import List
import Array exposing (Array)
import Native.Canvas
import Json.Decode as Json
import Color exposing (Color)
import Task exposing (Task)



-- TYPES


type alias Position = 
  { x : Int, y : Int }

type Canvas
  = Canvas

type Image
  = Image

type Error 
  = Error


initialize : Int -> Int -> Canvas
initialize width height =
  Native.Canvas.initialize width height


-- fill


fill : Color -> Canvas -> Canvas
fill = 
  Native.Canvas.fill 


-- getSize


getSize : Canvas -> (Int, Int)
getSize =
  Native.Canvas.getSize


-- drawCanvas


drawCanvas : Canvas -> Position -> Canvas -> Canvas
drawCanvas =
  Native.Canvas.drawCanvas


-- loadImage


loadImage : String -> Task Error Image
loadImage =
    Native.Canvas.loadImage


-- drawImage 


drawImage : Image -> Position -> Canvas -> Canvas
drawImage =
  Native.Canvas.drawImage


-- getImageData


getImageData : Canvas -> Array Int
getImageData =
  Native.getImageData 


-- setPixel


setPixel : Color -> Position -> Canvas -> Canvas
setPixel =
  Native.Canvas.setPixel 


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


-- toHtml


toHtml : List (Attribute msg) -> Canvas -> Html msg
toHtml =
  Native.Canvas.toHtml





