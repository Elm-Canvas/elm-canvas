import Html exposing (p, text, div, Html)
import Html.Attributes exposing (id, style)
import Canvas exposing (Canvas)
import List exposing (repeat, concat)
import Array exposing (fromList)




main =
  Html.beginnerProgram
  { model  = model
  , view   = view
  , update = identity
  }



-- MODEL


type alias Model = Canvas



model : Model
model =
  let
    width  = 500
    height = 400
  in
  { id = "the-canvas"
  , imageData =
    { width  = width
    , height = height
    , data   = 
        prettyBlue
        |>repeat (width * height)
        |>concat
        |>fromList
    }
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
  , Canvas.toHtml canvas []
  ]

