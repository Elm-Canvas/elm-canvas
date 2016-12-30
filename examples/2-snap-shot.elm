import Html exposing (p, text, div, canvas, Html)
import Html.Attributes exposing (id, style)
import Html.Events exposing (..)
import Canvas exposing (Canvas, Pixel)
import List exposing (repeat, concat)
import Mouse exposing (Position)
import Array exposing (fromList)
import Color exposing (rgb, Color)
import Debug exposing (log)


main = 
  Html.program
  { init  = (init, Cmd.none) 
  , view   = view 
  , update = update
  , subscriptions = always Sub.none
  }


-- MODEL


type alias Model = 
  { canvas : Canvas
  , snapshot : Canvas
  }



type Msg
  = Draw Position
  | TakeSnapshot



blankCanvas : Canvas
blankCanvas =
  let
    width  = 500
    height = 400
  in
  { id = "the-canvas"
  , imageData =
    { width  = width
    , height = height
    , data   = 
        black
        |>repeat (width * height)
        |>concat
        |>fromList
    }
  }


init : Model
init =
  { canvas = blankCanvas
  , snapshot = blankCanvas
  }



black : List Int
black =
  [ 0, 0, 0, 255 ]


prettyBlue : Color
prettyBlue =
  rgb 23 92 254



-- UPDATE


update :  Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of 

    Draw position ->
      (,)
      { model
      | canvas =
          Canvas.putPixels
            canvas
            [ Pixel prettyBlue position ]
      }
      Cmd.none

    TakeSnapshot ->
      ({ model | snapshot = model.canvas }, Cmd.none)



-- VIEW



view : Model -> Html Msg
view {canvas, snapshot} =
  div 
  [] 
  [ p [] [ text "Elm-Canvas" ]
  , Canvas.toHtml canvas [ Canvas.onMouseDown Draw ]
  , Canvas.toHtml snapshot []
  , input 
    [ type_ "submit"
    , value "take snapshot" 
    , onClick TakeSnapshot
    ] []
  ]



