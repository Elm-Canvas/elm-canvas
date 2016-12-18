module View exposing (..)

import Html             exposing (div, canvas, Html)
import Html.Attributes  exposing (class, style, id)
import Html.Events      exposing (..)
import Types            exposing (..)
import Components       exposing (..)
import List             exposing (repeat, map, concat, range)
import Array            exposing (Array, toIndexedList)


view : Model -> Html Msg
view model =
  div
  [ class "root" ]
  [ div 
    [] 
    [ ignorablePoint "Elm Canvas!" 
    , clickablePoint "Draw" Draw
    , canvas 
      [ id model.canvasName
      , style [ ("display", "table")]
      ]
      []
    ]
  ]




