module View exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import Components       exposing (..)
import Canvas


view : Model -> Html Msg
view {twoDivs} =
  let
    canvas' = 
      if twoDivs then
        div [] [ Canvas.toHtml [ id "neat-canvas" ] ]
      else
        Canvas.toHtml []
  in
  div [ class "root" ]
  [ ignorablePoint "Elm Canvas!"
  , break
  , clickablePoint "Mess up the html tree" MessItUp
  , break
  , canvas'
  ]