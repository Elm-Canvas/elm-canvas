import Html exposing (p, text, div, Html)
import Canvas exposing (ImageData)
import Color exposing (Color)




main =
  Html.beginnerProgram
  { model  = canvas
  , view   = view
  , update = identity
  }



-- MODEL


canvas : ImageData
canvas =
  Canvas.blank 500 400 prettyBlue


prettyBlue : Color
prettyBlue =
  Color.rgb 23 92 256



-- VIEW



view : ImageData -> Html msg
view canvas =
  div 
  [] 
  [ p [] [ text "Elm-Canvas" ] 
  , Canvas.toHtml "canvas-id" canvas []
  ]

