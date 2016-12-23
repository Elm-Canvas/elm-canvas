import Html exposing (p, text, div, Html)
import Html.Attributes exposing (id, style)
import Canvas
import List exposing (repeat, concat)




main =
  Html.beginnerProgram
  { model  = model
  , view   = view
  , update = identity
  }



-- MODEL


type alias Model = Canvas.ImageData



model : Model
model =
  let
    width  = 500
    height = 400
  in
  { width  = width
  , height = height
  , data   = 
      concat <| repeat (width * height) prettyBlue
  }


prettyBlue : List Int
prettyBlue =
  [ 23, 92, 254, 255 ]



-- VIEW



view : Model -> Html msg
view canvas =
  div 
  [] 
  [ p [] [ text "Elm-Canvas" ] 
  , Canvas.toHtml "the-canvas" canvas 
  ]

