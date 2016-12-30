import Html exposing (p, text, div, Html)
import Html.Events exposing (..)
import Canvas exposing (Canvas, Pixel)
import Mouse exposing (Position)
import Color exposing (Color)


main = 
  Html.program
  { init  = (model, Cmd.none) 
  , view   = view 
  , update = update
  , subscriptions = always Sub.none
  }


-- MODEL


type Msg
  = Draw Position


model : Canvas
model =
  Canvas.blank "the-canvas" 500 400 Color.black


-- UPDATE



update :  Msg -> Canvas -> (Canvas, Cmd Msg)
update message canvas =
  case message of 

    Draw position ->
      let 
        bluePixel = [ Pixel Color.blue position ] 
      in
        (Canvas.putPixels bluePixel canvas, Cmd.none)



-- VIEW



view : Canvas -> Html Msg
view canvas =
  div 
  [] 
  [ p [] [ text "Elm-Canvas" ]
  , Canvas.toHtml canvas [ Canvas.onMouseDown Draw ]
  ]