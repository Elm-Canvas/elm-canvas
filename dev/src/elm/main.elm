import Html exposing (..)
import Html.Attributes exposing (id, style, type_, value)
import Html.Events exposing (onClick)
import Canvas exposing (Canvas, Pixel)
import Mouse exposing (Position)
import Types exposing (..)
import Line exposing (line)
import Array
import Color

import Debug exposing (log)

main = 
  Html.program
  { init  = (init, Cmd.none) 
  , view   = view 
  , update = update
  , subscriptions = subscriptions
  }


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Mouse.ups MouseUp
  --Sub.batch 
  --[ Mouse.moves MouseMove
  --, Mouse.ups MouseUp
  --]



-- MODEL



initCanvas : String -> Canvas
initCanvas id =
  Canvas.blank id 500 400 Color.black


init : Model
init =
  { canvas = initCanvas "canvas" 
  , mouseDown = False
  , pixelsToChange = []
  , mousePosition = Position 0 0
  }


-- UPDATE



update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of 

    CanvasClick position ->
      (,)
      { model 
      | mouseDown      = True
      , mousePosition  = position
      , pixelsToChange =
          (bluePixel position) :: model.pixelsToChange
      }
      Cmd.none

    MouseUp position ->
      (,)
      { model | mouseDown = False }
      Cmd.none

    MouseMove position ->
      if model.mouseDown then
        (,)
        { model
        | pixelsToChange = [] 
        , mousePosition = position
        , canvas =
            let
              pixels =
                line position model.mousePosition
                |>List.map bluePixel
                |>List.append model.pixelsToChange 
            in
            Canvas.putPixels pixels model.canvas 
        }
        Cmd.none
      else
        (model, Cmd.none)


bluePixel : Position -> Pixel
bluePixel =
  Pixel Color.blue



-- VIEW



view : Model -> Html Msg
view {canvas} =
  div 
  [] 
  [ p 
    [] 
    [ text "Elm-Canvas" ]
  , div 
    []
    [ Canvas.toHtml 
        canvas 
        [ Canvas.onMouseDown CanvasClick 
        , Canvas.onMouseMove MouseMove
        ] 
    ]
  ]



