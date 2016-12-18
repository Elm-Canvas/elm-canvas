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
    [ ignorablePoint "Elm Canvas!" 
    , clickablePoint "Draw" Draw
    , mainCanvas model.canvasName
    ]
  ]

mainCanvas : String -> Html Msg
mainCanvas id_ = 
  let attr = [ id id_, style [ ("display", "table") ] ] in
  canvas attr 800 800 []


