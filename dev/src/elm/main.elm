import Html exposing (..)
import Html.Attributes exposing (id, style, type_, value)
import Html.Events exposing (onClick)
import Canvas exposing (Canvas, Pixel)
import Mouse exposing (Position)
import Color



main = 
  Html.program
  { init  = (init, Cmd.none) 
  , view   = view 
  , update = update
  , subscriptions = subscriptions
  }



-- SUBSCRIPTIONS



subscriptions : Model -> Sub Msg
subscriptions model =
  Mouse.ups MouseUp



-- MODEL



type Msg 
  = CanvasClick Position
  | MouseUp Position
  | MouseMove Position
  | ShowSwitch


type alias Model =
  { canvas : Canvas
  , mouseDown : Bool
  , mousePosition : Position
  , pixelsToChange : List Pixel
  , show : Bool
  }


init : Model
init =
  { canvas = Canvas.blank "canvas" 800 800 Color.black
  , mouseDown = False
  , pixelsToChange = []
  , mousePosition = Position 0 0
  , show = True
  }



-- UPDATE



update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of 

    CanvasClick position ->
      (,)
      { model 
      | mouseDown      = True
      , mousePosition  = position
      , pixelsToChange =
          (bluePixel position) :: model.pixelsToChange
      }
      Cmd.none

    MouseUp position ->
      ({ model | mouseDown = False }, Cmd.none)

    MouseMove position ->
      if model.mouseDown then
        (,)
        { model
        | pixelsToChange = [] 
        , mousePosition = position
        , canvas =
            let
              pixels =
                Canvas.line position model.mousePosition
                |>List.map bluePixel
                |>List.append model.pixelsToChange 
            in
            Canvas.putPixels pixels model.canvas 
        }
        Cmd.none
      else
        (model, Cmd.none)

    ShowSwitch ->
      ({ model | show = not model.show}, Cmd.none)


bluePixel : Position -> Pixel
bluePixel =
  Pixel Color.blue



-- VIEW



view : Model -> Html Msg
view model =
  let
    (canvas, inputLabel) = 
      if model.show then
        (,)
        [ Canvas.toHtml 
            model.canvas 
            [ Canvas.onMouseDown CanvasClick 
            , Canvas.onMouseMove MouseMove
            ] 
        ]
        "hide"
      else
        ([],"show")
  in
  div 
  [] 
  [ p [ ] [ text "Elm-Canvas" ]
  , input
    [ onClick ShowSwitch
    , value   inputLabel
    , type_   "submit"
    ]
    []
  , div [] canvas
  ]


