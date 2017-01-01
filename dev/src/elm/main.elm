import Html exposing (..)
import Html.Attributes exposing (id, style, type_, value)
import Html.Events exposing (onClick)
import Canvas exposing (Canvas, Pixel)
import Mouse exposing (Position)
import Array
import Color


main = 
  Html.program
  { init  = (init, Cmd.none) 
  , view   = view 
  , update = update
  , subscriptions = always Sub.none
  }



-- MODEL



type alias Model = 
  { canvas : Canvas
  , snapshot : Canvas
  }


type Msg
  = Draw Position
  | TakeSnapshot


initCanvas : String -> Canvas
initCanvas id =
  Canvas.blank id 500 400 Color.black


init : Model
init =
  { canvas = initCanvas "canvas"
  , snapshot = initCanvas "snapshot"
  }


origin = Position 0 0



-- UPDATE



update :  Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of 

    Draw position ->
      (,)
      { model 
      | canvas = 
          Canvas.putPixels 
            [ Pixel Color.white position ] 
            model.canvas 
      }
      Cmd.none

    TakeSnapshot ->
      (,)
      { model 
      | snapshot = 
          Canvas.putImageData 
            model.canvas.imageData 
            origin 
            model.snapshot 
      }
      Cmd.none



-- VIEW



view : Model -> Html Msg
view {canvas, snapshot} =
  div 
  [] 
  [ p 
    [] 
    [ text "Elm-Canvas" ]
  , input 
    [ type_ "submit"
    , value "take snapshot" 
    , onClick TakeSnapshot
    ] []
  , div 
    []
    [ Canvas.toHtml canvas [ Canvas.onMouseDown Draw ]
    , p [] [ text "snap shot:"]
    , Canvas.toHtml snapshot []
    ]
  ]



