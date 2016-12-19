module View exposing (..)

import Html             exposing (div,  Html)
import Html.Attributes  exposing (class, style, id)
import Html.Events      exposing (..)
import Types            exposing (..)
import Components       exposing (..)
import List             exposing (repeat, map, concat, range)
import Array            exposing (Array, toIndexedList)
import Canvas           exposing (canvas)


view : Model -> Html Msg
view model =
  div
  [ class "root" ]
  [ div 
    [] 
    [ ignorablePoint "Elm Canvas" 
    , mainCanvas model.canvasId
    ]
  ]

mainCanvas : String -> Html Msg
mainCanvas canvasId = 
  let 
    attr = 
      [ id canvasId
      , class "drawing-canvas"
      , onMouseDown HandleMouseDown
      ] 
  in
  canvas attr 400 400 []


