module View exposing (..)

import Html             exposing (div,  Html, text, p, Attribute)
import Html.Attributes  exposing (class, style, id)
import Html.Events      exposing (..)
import Types            exposing (..)
import Components       exposing (..)
import List             exposing (repeat, map, concat, range)
import Array            exposing (Array, toIndexedList)
import Canvas           exposing (canvas)
import Json.Decode as Json

leftPos : Json.Decoder Int
leftPos =
  Json.at ["target", "offsetLeft"] Json.int

leftPositionOnClick : (Int -> msg) -> Attribute msg
leftPositionOnClick tagger =
  on "click" (Json.map tagger leftPos)

mainCanvas : Model -> Html Msg
mainCanvas model = 
  Canvas.toHtml 
    model.canvas 
    [ leftPositionOnClick ClickCanvas ]

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



--onMouseDown : ()

top : Int -> (String, String)
top t = ("top", toString t ++ "px")

left : Int -> (String, String)
left l = ("left", toString l ++ "px")