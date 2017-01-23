import Html exposing (..)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onClick)
import Canvas exposing (Canvas, Position, Image, Error, Size)
import Task
import Color


main = 
  Html.program
  { init   = (initModel, initCmd) 
  , view   = view 
  , update = update
  , subscriptions = always Sub.none
  }



-- TYPES



type Msg
  = Draw Position
  | ImageLoaded (Result Error Image)


initModel : Canvas
initModel =
  Size 600 600
  |>Canvas.initialize
  |>Canvas.fill Color.black


initCmd : Cmd Msg
initCmd =
  Task.attempt ImageLoaded (Canvas.loadImage "./steelix.png")



redSquare : Canvas
redSquare =
  Size 30 30
  |>Canvas.initialize
  |>Canvas.fill Color.red



-- UPDATE



update :  Msg -> Canvas -> (Canvas, Cmd Msg)
update message canvas =
  case message of 

    Draw position ->
      (putRedSquare position canvas, Cmd.none)


    ImageLoaded imageResult ->
      case Result.toMaybe imageResult of
        Just image ->
          let 

            newCanvas =
              Canvas.getImageSize image
              |>Canvas.initialize
              |>Canvas.drawImage image (Position 0 0)
          
          in
            (newCanvas, Cmd.none)
        
        Nothing ->
          (canvas, Cmd.none)


putRedSquare : Position -> Canvas -> Canvas
putRedSquare position =
  Canvas.drawCanvas redSquare position



-- VIEW



view : Canvas -> Html Msg
view canvas =
  div []
  [ p [] [ text "Elm-Canvas" ]
  , Canvas.toHtml [ Canvas.onMouseDown Draw ] canvas
  ]




