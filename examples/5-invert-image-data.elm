import Html exposing (..)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onClick)
import Canvas exposing (Canvas, Position, Image, Error)
import Color
import Array exposing (Array)
import Task


main = 
  Html.program
  { init  = (initModel, initCmd) 
  , view   = view 
  , update = update
  , subscriptions = always Sub.none
  }



-- TYPES



type Msg
  = ImageLoaded (Result Error Image)
  | Invert


initModel : Canvas
initModel =
  Canvas.initialize 770 770 |> Canvas.fill Color.black


initCmd : Cmd Msg
initCmd =
  Task.attempt ImageLoaded (Canvas.loadImage "./agnes-martin-piece.png")




-- UPDATE



update : Msg -> Canvas -> (Canvas, Cmd Msg)
update message canvas =
  case message of 

    Invert ->
      let
        invertedCanvas =
          Canvas.drawCanvas 
            (invertCanvas canvas) 
            (Position 0 0) 
            canvas
      in
        (invertedCanvas, Cmd.none)

    ImageLoaded imageResult ->
      case Result.toMaybe imageResult of
        Just image ->
          (Canvas.drawImage image (Position 0 0) canvas, Cmd.none)
        
        Nothing ->
          (canvas, Cmd.none)


invertCanvas : Canvas -> Canvas
invertCanvas canvas = 
  let
    (width, height) = Canvas.getSize canvas
  in
    Canvas.getImageData canvas
    |>invertColors
    |>Canvas.fromImageData width height


invertColors : Array Int -> Array Int
invertColors = 
  Array.indexedMap invertColor 


invertColor : Int -> Int -> Int
invertColor index colorValue =
  if index % 4 == 3 then
    colorValue
  else
    255 - colorValue



-- VIEW



view : Canvas -> Html Msg
view canvas =
  div []
  [ h1 [] [ text "Click on the canvas to invert its colors" ]
  , Canvas.toHtml [ onClick Invert ] canvas
  ]




