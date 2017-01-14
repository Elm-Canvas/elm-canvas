import Html exposing (p, text, div, Html)
import Html.Attributes exposing (style)
import Html.Events exposing (..)
import Canvas exposing (Canvas, Position)
import Color exposing (Color)



main = 
  Html.program
  { init  = (init, Cmd.none) 
  , view   = view 
  , update = update
  , subscriptions = always Sub.none
  }


-- TYPES


type alias Model =
  { movePosition : Maybe Position 
  , clickPosition : Maybe Position
  , canvas : Canvas 
  }


init : Model
init =
  Canvas.initialize 500 400
  |>Canvas.fill Color.black
  |>Model Nothing Nothing


type Msg
  = MouseDown Position
  | MouseMove Position



-- UPDATE



update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of 

    MouseDown position0 ->
      case model.clickPosition of

        Just position1 ->

          let
            newModel =
              { model
              | clickPosition = Nothing
              , canvas = 
                  Canvas.drawLine
                    position0 
                    position1
                    Color.blue
                    model.canvas
              }

          in
            (newModel, Cmd.none)

        Nothing ->
          ({ model | clickPosition = Just position0 }, Cmd.none)

    MouseMove position ->
      ({ model | movePosition = Just position }, Cmd.none)



-- VIEW



view : Model -> Html Msg
view model =
  let 

    canvas = 
      case model.movePosition of

        Nothing -> model.canvas
        
        Just position0 ->
          case model.clickPosition of
            
            Nothing -> model.canvas
            
            Just position1 ->
              Canvas.drawLine
                position0
                position1
                (Color.hsl 0 0.5 0.5)
                model.canvas
  in
  div 
    [] 
    [ p [] [ text "Elm-Canvas" ]
    , Canvas.toHtml 
      [ Canvas.onMouseDown MouseDown
      , Canvas.onMouseMove MouseMove
      , style 
        [ ("cursor", "crosshair") ]
      ]
      canvas
    ]




