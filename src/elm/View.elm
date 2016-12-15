module View exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import Components       exposing (..)
import List             exposing (repeat, map)
import Array            exposing (Array, toIndexedList)
import Canvas


view : Model -> Html Msg
view model =
  div
  [ class "root" ]
  [ ignorablePoint "Elm Canvas!" 
  , clickablePoint "Add Canvas" AddCanvas
  , div 
    []
    (canvases model.canvases)
  ]


canvases : Array Canvas -> List (Html Msg)
canvases canvases' =
  canvases'
  |>toIndexedList
  |>map canvasView


canvasView : (Int, Canvas) -> Html Msg
canvasView (index, cv) =
  let {width, height, data} = cv in
  div 
  [ class "canvas-container"
  , style [ ("width", (toString width)) ] 
  ]
  [ clickablePoint 
      "Increase Width" 
      (IncreaseWidth index)
  , clickablePoint
      "Decrease WIdth"
      (DecreaseWidth index)
  , Canvas.canvas 
      [ id (toString index) ] 
      width
      height 
      data
  ]


