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
import Debug exposing (log)



-- TYPES


type alias Position = 
  { x : Int, y : Int }

type Canvas
  = Canvas

type Image
  = Image

type Error 
  = Error



-- initialize


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
  Native.Canvas.getImageData 


-- fromImageData


fromImageData : Int -> Int -> Array Int -> Canvas
fromImageData =
  Native.Canvas.fromImageData


-- setPixel


setPixel : Color -> Position -> Canvas -> Canvas
setPixel =
  Native.Canvas.setPixel 


-- setPixels 


setPixels : List (Color, Position) -> Canvas -> Canvas
setPixels =
  Native.Canvas.setPixels

getHighest : List Position -> Int
getHighest =
  List.map (.y) >> List.minimum >> Maybe.withDefault 0


getLeftest : List Position -> Int
getLeftest =
  List.map (.x) >> List.minimum >> Maybe.withDefault 0


getRightest : List Position -> Int
getRightest =
  List.map (.x) >> List.maximum >> Maybe.withDefault 0


getLowest : List Position -> Int
getLowest =
  List.map (.y) >> List.maximum >> Maybe.withDefault 0


relativize : Position -> (Color, Position) -> (Color, Position)
relativize {x, y} (color, p) =
  (color, Position (p.x - x) (p.y - y))


-- drawLine


drawLine : Position -> Position -> Color -> Canvas -> Canvas
drawLine =
  Native.Canvas.drawLine


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






