import Html exposing (..)
import Html.Attributes exposing (id, style, type_, value)
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
  , snapShotCount : Int
  }



type Msg
  = Draw Position
  | TakeSnapshot



initCanvas : String -> Canvas
initCanvas id =
  Canvas.blank id 500 400 Color.black



init : Model
init =
  { canvas = initCanvas "canvas"
  , snapshot = initCanvas "snapshot"
  , snapShotCount = 1
  }


origin = Position 0 0

-- UPDATE


update :  Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of 

    Draw position ->
      let 
        bluePixel = [ Pixel Color.blue position ] 

        {canvas} = model
      in
        (,)
        { model | canvas = Canvas.putPixels bluePixel canvas }
        Cmd.none

    TakeSnapshot ->
      (,)
      { model 
      | snapshot = 
          Canvas.putImageData 
            model.canvas.imageData 
            origin 
            model.snapshot
      , snapShotCount = model.snapShotCount + 1
      }
      Cmd.none



-- VIEW



view : Model -> Html Msg
view {canvas, snapshot, snapShotCount} =
  let
    snapshots =
      List.repeat snapShotCount (Canvas.toHtml snapshot [])
  in
  div 
  [] 
  [ p 
    [] 
    [ text "Elm-Canvas" ]

  , input 
    [ type_ "submit"
    , value "take snapshot" 
    , onClick TakeSnapshot
    ] []
  , div 
    []
    <|concat
      [ [ p [] [ text "draw here" ]
        , Canvas.toHtml canvas [ Canvas.onMouseDown Draw ]
        , p [] [ text "snap shot:"]
        ]
      , snapshots
      ]
  ]



