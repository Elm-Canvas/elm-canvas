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
          setPixels canvasId pixelsToChange
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
            |>pairWithColor (240, 30, 10, 255)
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

accountForCanvasPosition : (Int, Int) -> Canvas.Coordinate -> Canvas.Coordinate
accountForCanvasPosition (x0, y0) (x1, y1) =
  (x1 - x0, y1 - y0)


pairWithColor : Canvas.Color -> List Canvas.Coordinate -> List Canvas.Pixel
pairWithColor color =
  map ((,) . color)


handleDrawCompletion : List Canvas.Pixel -> Result Canvas.Error () -> Msg
handleDrawCompletion failedData result =
  case result of
    Err err ->
      DrawError failedData err

    Ok _ ->
      DrawSuccess


