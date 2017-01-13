import Html exposing (..)
import Html.Attributes exposing (style, type_, value)
import Html.Events exposing (onClick)
import Canvas exposing (Canvas, Position)
import Dict exposing (Dict)
import Color


main = 
  Html.program
  { init  = (init, Cmd.none) 
  , view   = view 
  , update = update
  , subscriptions = always Sub.none
  }



-- TYPES



type alias Model = 
  (Canvas, Canvas)


type Msg
  = Draw Position
  | TakeSnapshot


init : Model
init =
  (initializeBlack 400 300, initializeBlack 400 300)


initializeBlack : Int -> Int -> Canvas
initializeBlack width height =
  Canvas.initialize width height |> Canvas.fill Color.black



-- UPDATE



update :  Msg -> Model -> (Model, Cmd Msg)
update message (main, snapshot) =
  case message of 

    Draw position ->
      let 

        updatedMain =
          putWhitePixel position main

      in
        ((updatedMain, snapshot), Cmd.none)

    TakeSnapshot ->
      let

        newSnapshot =
          Canvas.drawCanvas main (Position 0 0) snapshot

      in
        ((main, newSnapshot), Cmd.none)


putWhitePixel : Position -> Canvas -> Canvas
putWhitePixel =
  Canvas.setPixel Color.white



-- VIEW



view : Model -> Html Msg
view (main, snapshot) =
  div [] 
  [ input 
    [ type_ "submit"
    , value "take snapshot" 
    , onClick TakeSnapshot
    ] []
  , canvasView [ Canvas.onMouseDown Draw ] main
  , p [] [ text "snapshot : "]
  , canvasView [] snapshot
  ]


canvasView : List (Attribute Msg) -> Canvas -> Html Msg
canvasView attr canvas =
  let 

    styleAttr =
      style [ ("cursor", "crosshair") ]

  in
    div [] [ Canvas.toHtml (styleAttr :: attr) canvas ]




