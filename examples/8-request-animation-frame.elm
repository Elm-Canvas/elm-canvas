import Html exposing (..)
import Html.Attributes exposing (style, type_, value)
import Html.Events exposing (onClick)
import Canvas exposing (Canvas, Position, Image, Error, Size)
import AnimationFrame exposing (diffs)
import Time exposing (Time)
import Color
import Task



main = 
  Html.program
  { init  = (init, initCmd) 
  , view   = view 
  , update = update
  , subscriptions = subscriptions
  }


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
  diffs Tick



-- TYPES



type alias Model = 
  { main : Canvas
  , image : Maybe Image
  , pendingDraws : List (Canvas -> Canvas)
  }


type Msg
  = Draw Position
  | ImageLoaded (Result Error Image)
  | Tick Time


init : Model
init =
  Model (initializeBlack (Size 700 550)) Nothing []


initializeBlack : Size -> Canvas
initializeBlack =
  Canvas.initialize >> Canvas.fill Color.black


initCmd : Cmd Msg
initCmd =
  Task.attempt 
    ImageLoaded 
    (Canvas.loadImage "elm-logo.png")



-- UPDATE



update :  Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of 

    Draw position ->
      case model.image of

        Just img ->
          let
            newModel =
              { model
              | pendingDraws =
                  let
                    newDraw =
                      let
                        p =
                          let
                            {x, y} = position
                            {width, height} = 
                              Canvas.getImageSize img
                          in
                            Position 
                              (x - (width // 2)) 
                              (y - (height // 2))
                      in
                        Canvas.drawImage img p
                  in
                    newDraw :: model.pendingDraws
              } 
          in
            (newModel, Cmd.none)

        Nothing ->
          (model, Cmd.none)


    ImageLoaded result ->
      ({ model | image = Result.toMaybe result }, Cmd.none)


    Tick _ ->
      let 
        newModel =
          { model
          | main =
              List.foldr 
                (<|) 
                model.main 
                model.pendingDraws
          , pendingDraws = []
          }
      in
        (newModel, Cmd.none)



-- VIEW



view : Model -> Html Msg
view {main} = 
  div 
  [ ]
  [ Canvas.toHtml
    [ style [ ("cursor", "crosshair") ]
    , Canvas.onMouseMove Draw
    ]
    main
  ]




