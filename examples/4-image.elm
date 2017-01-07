import Html exposing (..)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onClick)
import Canvas exposing (ImageData, Position, Image, Error)
import Task
import Color


main = 
  Html.program
  { init   = (initModel, initCmd) 
  , view   = view 
  , update = update
  , subscriptions = always Sub.none
  }



-- TYPES



type alias Model = 
  (String, ImageData)


type Msg
  = Draw Position
  | ImageLoaded (Result Error Image)


blankCanvas : ImageData
blankCanvas =
  Canvas.blank 600 600 Color.black



initModel : Model
initModel =
  ("the-canvas", blankCanvas)


initCmd : Cmd Msg
initCmd =
  Task.attempt ImageLoaded (Canvas.loadImage "./steelix.png")


redSquare : ImageData
redSquare =
  Canvas.blank 20 20 Color.red



-- UPDATE



update :  Msg -> Model -> (Model, Cmd Msg)
update message (id, imageData) =
  case message of 

    Draw position ->
      let 
        canvas =
          putRedSquare position id
          |>Maybe.withDefault blankCanvas
          |>(,) id
      in
      (canvas, Cmd.none)


    ImageLoaded imageResult ->
      case Result.toMaybe imageResult of
        Just image ->
          let
            canvas =
              Canvas.drawImage image Canvas.origin id
              |>Maybe.withDefault blankCanvas
              |>(,) id
          in
          (canvas, Cmd.none)
        
        Nothing ->
          ((id, imageData), Cmd.none)


putRedSquare : Position -> String -> Maybe ImageData
putRedSquare =
  Canvas.put redSquare



-- VIEW



view : Model -> Html Msg
view (id, imageData) =
  let {width, height} = imageData in
  div []
  [ p [] [ text "Elm-Canvas" ]
  , Canvas.toHtml id imageData 
    [ Canvas.size (width, height)
    , Canvas.onMouseDown Draw
    ] 
  ]





