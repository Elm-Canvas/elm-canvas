import Html exposing (p, text, div, Html)
import Html.Attributes exposing (style)
import Html.Events exposing (..)
import Canvas exposing (Canvas, Position)
import Color exposing (Color)


main = 
  Html.program
  { init  = (init, Cmd.none) 
  , view   = view 
  , update = update
  , subscriptions = always Sub.none
  }


init : Canvas
init = 
  Canvas.fill Color.black <| Canvas.initialize 500 400



-- TYPES


type Msg
  = Draw Position



-- UPDATE



update : Msg -> Canvas -> (Canvas, Cmd Msg)
update message canvas =
  case message of 

    Draw position ->
      (addWhitePixel position canvas, Cmd.none)


addWhitePixel : Position -> Canvas -> Canvas
addWhitePixel =
  Canvas.setPixel Color.white



-- VIEW



view : Canvas -> Html Msg
view canvas =
  let 
    (width, height) =
      Canvas.getSize canvas
  in
  div 
  [] 
  [ p [] [ text "Elm-Canvas" ]
  , Canvas.toHtml 
    [ Canvas.onMouseDown Draw
    , style 
      [ ("width", toString width)
      , ("height", toString height)
      , ("cursor", "crosshair")
      ]
    ]
    canvas
  ]




