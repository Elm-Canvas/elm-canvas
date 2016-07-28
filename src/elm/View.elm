module View exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import Components       exposing (..)


view : Model -> Html Msg
view m = 
  div [ class "root" ]
  [ ignorablePoint "Dank"
  , break
  , clickablePoint "Draw" Draw
  , break
  , canvas [ id "number-1-canvas" ] []
  ]