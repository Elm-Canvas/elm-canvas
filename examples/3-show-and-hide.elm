import Html exposing (..)
import Html.Attributes exposing (type_, value, style)
import Html.Events exposing (onClick)
import Canvas exposing (Canvas, Position)
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
  { show : Bool, canvas : Canvas }


type Msg
  = Draw Position
  | ShowSwitch


init : Model
init =
  Canvas.initialize 400 300 
  |>Canvas.fill Color.black
  |>Model True


blueSquare : Canvas
blueSquare =
  Canvas.initialize 30 30 |> Canvas.fill Color.blue



-- UPDATE



update :  Msg -> Model -> (Model, Cmd Msg)
update message {show, canvas} =
  case message of 

    Draw position ->
      let 
        updatedCanvas =
          putBlueSquare position canvas         
      in
       (Model show updatedCanvas, Cmd.none)

    ShowSwitch ->
      (Model (not show) canvas, Cmd.none)


putBlueSquare : Position -> Canvas -> Canvas
putBlueSquare position =
  Canvas.drawCanvas blueSquare position



-- VIEW



view : Model -> Html Msg
view {canvas, show} =
  if show then
    container
    [ Canvas.toHtml
      [ Canvas.onMouseDown Draw
      , style
        [ ("border", "1px solid #000000")
        , ("cursor", "crosshair")
        ]
      ]
      canvas
    ]
  else
    container []


container : List (Html Msg) -> Html Msg
container canvas =
  div
  []
  [ p [] [ text "Elm-Canvas" ]
  , input 
    [ type_ "submit"
    , value "show / hide" 
    , onClick ShowSwitch
    ] []
  , div [] canvas
  ]




