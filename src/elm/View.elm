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
    [ div 
      [ class "canvas-container" ]
      [ ignorablePoint "Elm Canvas" 
      , clickablePoint "Populate with black" Populate
      , mainCanvas model 
      ]
    ]
  ]

mainCanvas : Model -> Html Msg
mainCanvas {canvasId, canvasCoordinates} = 
  let 
    attr = 
      let (x, y) = canvasCoordinates in
      [ id canvasId
      , style
        [ ("position", "absolute")
        , top y
        , left x
        ]
      , class "drawing-canvas"
      , onMouseDown HandleMouseDown
      ] 
  in
  --repeat (400 * 400) [ 0, 0, 0, 255 ]
  --|>concat
  --|>canvas attr 400 400
  canvas attr 400 400 []

top : Int -> (String, String)
top t = ("top", toString t ++ "px")

left : Int -> (String, String)
left l = ("left", toString l ++ "px")