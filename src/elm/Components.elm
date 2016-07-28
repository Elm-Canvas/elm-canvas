module Components exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import Json.Decode      as Json


point : String -> Html Msg
point str =
  p [ class "point" ] [ text str ]

ignorablePoint : String -> Html Msg
ignorablePoint str =
  p [ class "point ignorable" ] [ text str]

clickablePoint : String -> Msg -> Html Msg
clickablePoint str msg =
  p 
  [ class "point clickable" 
  , onClick msg
  ] 
  [ text str]

break : Html Msg
break = br [] []



--onKeyDown : (Int -> Msg) -> Attribute Msg
--onKeyDown msg =
--  on "keydown" <|Json.map msg keyCode

--inputField : String -> Html Msg
--inputField str =
--  input
--  [ class        "input-field"
--  , value        str
--  , onInput      UpdateField
--  , spellcheck   False
--  , onKeyDown    CheckForEnter
--  ]
--  []
