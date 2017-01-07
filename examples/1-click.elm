import Html exposing (p, text, div, Html)
import Html.Events exposing (..)
import Canvas exposing (ImageData, Pixel)
import Mouse exposing (Position)
import Color exposing (Color)


main = 
  Html.program
  { init  = (canvas, Cmd.none) 
  , view   = view 
  , update = update
  , subscriptions = always Sub.none
  }


-- MODEL


type Msg
  = Draw Position


canvas : ImageData
canvas = 
  Canvas.blank 500 400 Color.black


canvasId = "canvas-id"



-- UPDATE



update : Msg -> ImageData -> (ImageData, Cmd Msg)
update message imageData =
  case message of 

    Draw position ->
      (addBluePixel position, Cmd.none)


addBluePixel : Position -> ImageData
addBluePixel =
  Pixel Color.blue >> Canvas.setPixel canvasId >> Maybe.withDefault canvas



-- VIEW



view : ImageData -> Html Msg
view imageData =
  div 
  [] 
  [ p [] [ text "Elm-Canvas" ]
  , Canvas.toHtml 
      canvasId 
      imageData 
      [ Canvas.onMouseDown Draw
      , Canvas.size 
          (imageData.width, imageData.height)
      ]
  ]




