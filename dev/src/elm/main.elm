import Html             exposing (p, text)
import Html.Attributes  exposing (class)
import List             exposing (repeat, map, range, concat)
import Array            exposing (Array, fromList, push, get, set)
import Types            exposing (..)
import View             exposing (view)
import Maybe            exposing (withDefault)
import Canvas           exposing (Pixel)
import Color            exposing (Color, rgb)
import Task             exposing (attempt)
import Mouse            exposing (Position)
import Line             exposing (line)
import Ports            exposing (populate)
import Debug            exposing (log)

(.) = flip 

initModel : Model
initModel =
  { canvasId          = "the-canvas"
  , mousePosition     = Position 0 0 
  , mouseDown         = False
  , pixelsToChange    = [] 
  , canvasCoordinates = (300, 300)
  , data              = 
      repeat (400 * 400) [ 0, 0, 0, 255 ]
      |>concat
  }


main =
  Html.program
  { init          = (initModel, populate "the-canvas") 
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


update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of 
    Draw ->
      let 
        msg = 
          let {canvasId, pixelsToChange} = model in
          Canvas.setPixels canvasId pixelsToChange
          |>attempt (handleDrawCompletion pixelsToChange)
      in
      ({ model | pixelsToChange = [] }, msg)

    DrawError failedData err ->
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
        {mousePosition, mouseDown, canvasCoordinates} = model
        model_ =
          { model | mousePosition = position}
      in
      if mouseDown then
        let 
          pixels =
            line mousePosition position
            |>map (accountForCanvasPosition canvasCoordinates)
            |>map (Pixel (rgb 80 0 87)) 
        in
        update (AppendPixels pixels) model_
      else
        (model_, Cmd.none)

    AppendPixels pixels ->
      let {pixelsToChange} = model in
      { model 
      | pixelsToChange =
          concat [ pixelsToChange, pixels ]
      }
      |>update Draw

    Populate ->
      (model, populate (model.canvasId))

accountForCanvasPosition : (Int, Int) -> Position -> Position
accountForCanvasPosition (cx, cy) {x, y} =
  Position (x - cx) (y - cx)



handleDrawCompletion : List Canvas.Pixel -> Result Canvas.Error () -> Msg
handleDrawCompletion failedData result =
  case result of
    Err err ->
      DrawError failedData err

    Ok _ ->
      DrawSuccess


