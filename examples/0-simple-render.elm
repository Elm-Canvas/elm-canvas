import Html exposing (p, text, div, Html)
import Html.Attributes exposing (style)
import Canvas exposing (Canvas)
import Color exposing (Color)


main =
  let
  
    width = 400

    height = 300

    canvasStyle = 
      style 
      [ ("width", toString width) 
      , ("height", toString height)
      , ("border", "1px solid #000000")
      ]

  in
    div 
    [] 
    [ p [] [ text "Elm-Canvas" ] 
    , Canvas.initialize width height
      |>Canvas.fill (Color.rgb 23 92 254)
      |>Canvas.toHtml [ canvasStyle ]
    ]



