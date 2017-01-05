import Html exposing (p, text, div, Html, Attribute)
import Html.Attributes exposing (style, width, height)
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



view : ImageData -> Html a
view imageData =
  div 
  [] 
  [ p [] [ text "Elm-Canvas" ] 
  , Canvas.toHtml "canvas-id" imageData [ blackBorder ]
  ]


blackBorder : Attribute
blackBorder =
  style [ ("border", "1px solid #000000") ]





