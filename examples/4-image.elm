import Html exposing (..)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onClick)
import Canvas exposing (Canvas, Position, Image, Error, Size)
import Task
import Color


main = 
  Html.program
  { init   = (Loading, loadImage) 
  , view   = view 
  , update = update
  , subscriptions = always Sub.none
  }



-- TYPES



type Msg
  = Draw Position
  | ImageLoaded (Result Error Image)


type Model
  = GotCanvas Canvas
  | Loading


loadImage : Cmd Msg
loadImage =
  Task.attempt ImageLoaded (Canvas.loadImage "./steelix.png")


redSquare : Canvas
redSquare =
  Size 30 30
  |>Canvas.initialize
  |>Canvas.fill Color.red



-- UPDATE



update :  Msg -> Model -> (Model, Cmd Msg)
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

        Draw position ->
          let
            newCanvas =
              Canvas.drawCanvas 
                redSquare 
                position 
                canvas
          in
            (GotCanvas newCanvas, Cmd.none)


        _ ->

          (model, Cmd.none)



-- VIEW



view : Model -> Html Msg
view model =
  let

    body =
      case model of

        Loading ->
          p [] [ text "Loading image" ]


        GotCanvas canvas ->
          Canvas.toHtml 
            [ Canvas.onMouseDown Draw ] 
            canvas
  
  in
    div []
    [ p [] [ text "Elm-Canvas" ] 
    , body
    ]





