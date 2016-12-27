import Html exposing (p, text, div, Html)
import Html.Attributes exposing (id, style)
import Canvas
import List exposing (repeat, concat)
import Mouse exposing (Position)




main = 
  Html.program
  { model  = model 
  , view   = view 
  , update = update
  }


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Mouse.downs Draw


-- MODEL


type alias Model = Canvas.ImageData


type Msg
  = Draw Position


model : Model
model =
  let
    width  = 500
    height = 400
  in
  { width  = width
  , height = height
  , data   = 
      concat <| repeat (width * height) black
  }


black : List Int
black =
  [ 0, 0, 0, 255 ]


prettyBlue : List Int
prettyBlue =
  [ 23, 92, 254, 255 ]



-- UPDATE


update : Model -> Msg -> (Model, Cmd Msg)
update model message =
  case message of 

    Draw position ->
      let






-- VIEW



view : Model -> Html msg
view canvas =
  div 
  [] 
  [ p [] [ text "Elm-Canvas" ] 
  , Canvas.toHtml "the-canvas" canvas 
  ]



