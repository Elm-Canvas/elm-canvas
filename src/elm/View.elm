module View exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import Components       exposing (..)
import List             exposing (repeat)
import Canvas


view : Model -> Html Msg
view {twoDivs} =
  let
    canvas' = 
      let
        data =  
          repeat (256 * 4) 159
      in
      if twoDivs then
        div [] [ Canvas.canvas [ id "neat-canvas" ] 16 16 data ]
      else
        Canvas.canvas [] 16 16 data
  in
  div [ class "root" ]
  [ ignorablePoint "Elm Canvas!"
  , break
  , clickablePoint "Mess up the html tree" MessItUp
  , break
  , canvas'
  ]