import Html exposing (..)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onClick)
import Canvas exposing (Canvas, Position, Image, Error, Size)
import Color
import Array exposing (Array)
import Task


main = 
  Html.program
  { init  = (Loading, loadImage) 
  , view   = view 
  , update = update
  , subscriptions = always Sub.none
  }



-- TYPES



type Msg
  = ImageLoaded (Result Error Image)
  | Invert


type Model
  = GotCanvas Canvas
  | Loading


loadImage : Cmd Msg
loadImage =
  Task.attempt ImageLoaded (Canvas.loadImage "./agnes-martin-piece.png")




-- UPDATE



update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case model of 

    Loading ->
      case message of 

        ImageLoaded result ->

          case Result.toMaybe result of
          
            Just image ->
              let 
                canvas =
                  Canvas.fromImage image
              in
                (GotCanvas canvas, Cmd.none)

            Nothing ->

              (Loading, loadImage)

        _ ->

          (model, Cmd.none)


    GotCanvas canvas ->
      case message of

        Invert ->

          (GotCanvas <| invertCanvas canvas, Cmd.none)


        _ ->

          (model, Cmd.none)


invertCanvas : Canvas -> Canvas
invertCanvas canvas = 
  let

    imageData =
      Canvas.getImageData canvas

    size = 
      Canvas.getCanvasSize canvas
  
  in
    Canvas.fromImageData size (invertColors imageData)


invertColors : Array Int -> Array Int
invertColors = 
  Array.indexedMap invertColor 


invertColor : Int -> Int -> Int
invertColor index colorValue =
  if index % 4 == 3 then
    colorValue
  else
    255 - colorValue



-- VIEW



view : Model -> Html Msg
view model =
  let

    body =
      case model of

        Loading ->
          p [] [ text "Loading image.."]

        GotCanvas canvas ->
          Canvas.toHtml
            [ onClick Invert ]
            canvas

  in
    div []
    [ h1 [] [ text "Click on the canvas to invert its colors" ]
    , body
    ]




