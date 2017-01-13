import Html exposing (..)
import Html.Attributes exposing (style, type_, value)
import Html.Events exposing (onClick)
import Canvas exposing (Canvas, Position, Image, Error)
import Dict exposing (Dict)
import Color
import Task



main = 
  Html.program
  { init  = (init, initCmd) 
  , view   = view 
  , update = update
  , subscriptions = always Sub.none
  }



-- TYPES



type alias Model = 
  { main : Canvas
  , snapshot : Canvas
  , image : Maybe Image
  }


type Msg
  = Draw Position
  | TakeSnapshot
  | ImageLoaded (Result Error Image)


init : Model
init =
  Model 
    (initializeBlack 400 300)
    (initializeBlack 100 100)
    Nothing


redSquare : Canvas
redSquare =
  Canvas.drawRectangle 
    (Position 150 100) 
    100 
    100 
    Color.red
    (Canvas.initialize 400 300)


initializeBlack : Int -> Int -> Canvas
initializeBlack width height =
  Canvas.initialize width height |> Canvas.fill Color.black


initCmd : Cmd Msg
initCmd =
  Task.attempt 
    ImageLoaded 
    (Canvas.loadImage "./cia_head.png")



-- UPDATE



update :  Msg -> Model -> (Model, Cmd Msg)
update message {main, snapshot, image} =
  case message of 

    Draw position ->
      case image of

        Just img ->
          let 
            newMain =
              let 
                 p =
                  let 
                    {x,y} = position 
                    (w,h) = Canvas.getImageSize img
                  in
                  Position (x - (w // 2)) (y - (h // 2))
              in
              Canvas.drawImage img p main
          in
            (Model newMain snapshot image, Cmd.none)

        Nothing ->
          (Model main snapshot image, Cmd.none)


    TakeSnapshot ->
      let

        newSnapshot =
          let
            croppedMain =
              Canvas.crop 
                (Position 150 100) 
                100 
                100 
                main
          in
            Canvas.drawCanvas 
              croppedMain 
              (Position 0 0) 
              snapshot

      in
        (Model main newSnapshot image, Cmd.none)


    ImageLoaded result ->
      (Model main snapshot (Result.toMaybe result), Cmd.none)



-- VIEW



view : Model -> Html Msg
view {main, snapshot} =
  div [] 
  [ input 
    [ type_ "submit"
    , value "take snapshot" 
    , onClick TakeSnapshot
    ] []
  
  , mainCanvasView main

  , p [] [ text "snapshot : "]
  , div 
    [ style [ ("display", "block") ] ] 
    [ Canvas.toHtml [] snapshot ]
  ]


mainCanvasView : Canvas -> Html Msg
mainCanvasView canvas = 
  div 
  [ style 
    [ ("position", "relative") 
    , ("width", "400px")
    , ("height", "300px")
    ] 
  ]
  [ Canvas.toHtml
    [ style 
      [ ("position", "absolute")
      , ("left", "0px")
      , ("top", "0px")
      ]
    ]
    canvas
  , Canvas.toHtml 
    [ Canvas.onMouseMove Draw
    , style 
      [ ("cursor", "crosshair") 
      , ("position", "absolute")
      , ("left", "0px")
      , ("top", "0px")
      ]
    ]
    redSquare
  ]




