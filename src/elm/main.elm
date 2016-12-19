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
import Line             exposing (line)
import Debug            exposing (log)

(.) = flip 

initModel : Model
initModel =
  { canvasId       = "the-canvas"
  , mousePosition  = Position 0 0 
  , mouseDown      = False
  , pixelsToChange = [] 
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
    [ Mouse.moves SetPosition
    , Mouse.ups HandleMouseUp 
    ]
  else
    Mouse.moves SetPosition

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
  [ ((x, y), (235, 20, 10, 255)) ]

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of 
    Draw ->
      let 
        msg = 
          let {canvasId, pixelsToChange} = model in
          setPixels canvasId pixelsToChange
          |>attempt handleDrawCompletion
      in
      ({ model | pixelsToChange = [] }, msg)

    DrawError err ->
      let _ = Debug.crash "ERROR : " ++ (toString err) in
      (model, Cmd.none)

    DrawSuccess ->
      (model, Cmd.none)

    HandleMouseDown ->
      let {mousePosition} = model in
      ({ model | mouseDown = True }, Cmd.none)

    HandleMouseUp _ ->
      ({ model | mouseDown = False }, Cmd.none)

    SetPosition position ->
      let 
        {mousePosition, mouseDown} = model

        model_ =
          { model | mousePosition = position}

      in
      if mouseDown then
        let 
          pixels =
            map 
              ((,) . (240, 30, 10, 255)) 
              (line mousePosition position)
          --_ = log "HERE THO" "HERE"
        in
        update (AppendPixels pixels) model_
      else
        (model_, Cmd.none)

    AppendPixels pixels ->
      let {pixelsToChange} = model in
      { model 
      | pixelsToChange =
          concat [ pixelsToChange, pixels ]
          --((x, y), (235, 30, 10, 255)) :: pixelsToChange
      }
      |>update Draw


handleDrawCompletion : Result Canvas.Error () -> Msg
handleDrawCompletion result =
  case result of
    Err err ->
      DrawError err

    Ok _ ->
      DrawSuccess


