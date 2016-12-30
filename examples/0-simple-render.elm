import Html exposing (p, text, div, Html)
import Canvas exposing (Canvas)
import Color exposing (Color)




main =
  Html.beginnerProgram
  { model  = canvas
  , view   = view
  , update = identity
  }




-- MODEL


canvas : Canvas
canvas =
  Canvas.blank "the-canvas" 500 400 prettyBlue


prettyBlue : Color
prettyBlue =
  Color.rgb 23 92 256



-- VIEW



view : Canvas -> Html msg
view canvas =
  div 
  [] 
  [ p [] [ text "Elm-Canvas" ] 
  , Canvas.toHtml canvas []
  ]

