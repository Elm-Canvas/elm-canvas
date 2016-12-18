import Html             exposing (p, text)
import Html.Attributes  exposing (class)
import List             exposing (repeat, map, range, concat)
import Array            exposing (Array, fromList, push, get, set)
import Types            exposing (..)
import View             exposing (view)
import Maybe            exposing (withDefault)
import Canvas           exposing (setPixels, Pixel)
import Task             exposing (attempt)
import Debug            exposing (log)

(.) = flip 

initModel : Model
initModel =
  { field = ""
  , canvasName = "the-canvas"
  }

main =
  Html.program
  { init          = (initModel, Cmd.none) 
  , view          = view
  , update        = update
  , subscriptions = always Sub.none
  }

aPixel : Int -> Int -> Pixel
aPixel b a =
  ((b, a), (255, a, (255 - (3 * a) % 256), 255))

somePixels : List Pixel
somePixels =
  map 
    (\c -> map (aPixel c) (range 0 500))
    (range 0 200)
  |>concat

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of 

    Draw ->
      let
        msg =
          attempt
            handleDrawCompletion
            (setPixels model.canvasName somePixels)
      in
      (model, msg)

    DrawError err ->
      (model, Cmd.none)

    DrawSuccess val ->
      ({model | field = val }, Cmd.none)


handleDrawCompletion : Result Canvas.Error () -> Msg
handleDrawCompletion result =
  case result of
    Err err ->
      DrawError err

    Ok _ ->
      DrawSuccess "neato"


