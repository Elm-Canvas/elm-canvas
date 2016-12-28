module View exposing (..)

import Html             exposing (div,  Html, text, p, Attribute)
import Html.Attributes  exposing (class, style, id)
import Html.Events      exposing (..)
import Types            exposing (..)
import Components       exposing (..)
import List             exposing (repeat, map, concat, range)
import Array            exposing (Array, toIndexedList)
import Canvas           exposing (canvas, Position)


width : Int -> (String, String)
width i =
  ("width", (toString i) ++ "px")

height : Int -> (String, String)
height i =
  ("height", (toString i) ++ "px")

mainCanvas : Model -> Html Msg
mainCanvas {canvas} = 
  Canvas.toHtml 
    canvas 
    [ Canvas.onMouseDown ClickCanvas
    , style
      [ width canvas.imageData.width
      , height canvas.imageData.height
      ]
    ]

view : Model -> Html Msg
view model =
  div
  [ class "root" ]
  [ div 
    [] 
    [ div 
      [ class "canvas-container" ]
      [ ignorablePoint "Elm Canvas" 
      , mainCanvas model 
      ]
    ]
  ]


top : Int -> (String, String)
top t = ("top", toString t ++ "px")

left : Int -> (String, String)
left l = ("left", toString l ++ "px")