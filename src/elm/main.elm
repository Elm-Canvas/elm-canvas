import Html             exposing (p, text)
import Html.Attributes  exposing (class)
import List             exposing (repeat, map, range, concat)
import Array            exposing (Array, fromList, push, get, set)
import Types            exposing (..)
import View             exposing (view)
import Maybe            exposing (withDefault)
import Canvas           exposing (setPixels, Pixel)
import Task             exposing (attempt)
import Mouse            exposing (Position)
import Debug            exposing (log)

(.) = flip 

initModel : Model
initModel =
  { canvasName    = "the-canvas"
  , mousePosition = Position 0 0 
  , mouseDown     = False
  }

main =
  Html.program
  { init          = (initModel, Cmd.none) 
  , view          = view
  , update        = update
  , subscriptions = subscriptions
  }

subscriptions : Model -> Sub Msg
subscriptions {mouseDown} =
  if mouseDown then
    Sub.batch 
    [ Mouse.moves MovingTo
    , Mouse.ups HandleMouseUp 
    ]
  else
    Sub.none

  --case model.mouseDown of
  --  Nothing ->
  --    Sub.none

  --  Just _ ->
  --    Sub.batch [ Mouse.moves DragAt, Mouse.ups DragEnd ]

aPixel : Int -> Int -> Pixel
aPixel b a =
  ((b, a), (255, (2 * a) % 256, (255 - (3 * a) % 256), 255))

somePixels : List Pixel
somePixels =
  map 
    (\c -> map (aPixel c) (range 0 500))
    (range 0 300)
  |>concat

colorPixel : Position -> List Pixel
colorPixel {x, y} =
  [ ((x, y), (0, 0, 255, 255)) ]

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of 

    PopulateData ->
      let
        msg =
          attempt
            handleDrawCompletion
            (setPixels model.canvasName somePixels)
      in
      (model, msg)

    DrawError err ->
      (model, Cmd.none)

    DrawSuccess ->
      (model, Cmd.none)

    HandleMouseDown ->
      ({ model | mouseDown = True }, Cmd.none)

    HandleMouseUp _ ->
      ({ model | mouseDown = False }, Cmd.none)

    MovingTo position ->
      let
        msg =
          position
          |>colorPixel
          |>setPixels model.canvasName
          |>attempt handleDrawCompletion
      in
      (model, msg)


handleDrawCompletion : Result Canvas.Error () -> Msg
handleDrawCompletion result =
  case result of
    Err err ->
      DrawError err

    Ok _ ->
      DrawSuccess


