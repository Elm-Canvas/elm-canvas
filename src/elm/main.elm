import Html             exposing (p, text)
import Html.Attributes  exposing (class)
import Html.App         as App
import List             exposing (repeat)
import Array            exposing (Array, fromList, push, get, set)
import Types            exposing (..)
import Ports            exposing (..)
import View             exposing (view)
import Maybe            exposing (withDefault)
import Debug            exposing (log)


(.) = flip 

initCanvas : Canvas
initCanvas =
  { width  = 256
  , height = 256
  , data   = repeat (256 * 256 * 4) 255
  } 

initModel : Model
initModel =
  { canvases = 
      fromList [ initCanvas ]
  }

main =
  App.program
  { init          = (initModel, Cmd.none) 
  , view          = view
  , update        = update
  , subscriptions = subscriptions
  }

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of 

    AddCanvas ->
      { model
      | canvases =
          push initCanvas model.canvases 
      }
      |>flip (,) Cmd.none

    UpdateCanvas index canvas ->
      let {canvases} = model in
      bundle
      { model
      | canvases = set index canvas canvases
      }

    IncreaseWidth index ->
      let {canvases} = model in
      updateCanvas index canvases increaseWidth
      |>update . model

    DecreaseWidth index ->
      let {canvases} = model in
      updateCanvas index canvases decreaseWidth
      |>update . model

    _ -> (model, Cmd.none)

updateCanvas : Int -> Array Canvas -> (Canvas -> Canvas) -> Msg
updateCanvas index canvases transformation =
  get index canvases
  |>withDefault initCanvas
  |>transformation
  |>UpdateCanvas index 

bundle : Model -> (Model, Cmd Msg)
bundle model = (model, Cmd.none)

decreaseWidth : Canvas -> Canvas
decreaseWidth canvas =
  { canvas
  | width = canvas.width - 1
  } 

increaseWidth : Canvas -> Canvas
increaseWidth canvas =
  { canvas
  | width = canvas.width + 1
  }

    --Switch ->
    --  { model | switch = (not model.switch) }
    --  |>flip (,) Cmd.none

    --Increase ->
    --  { model | amount = model.amount + 1 }
    --  |>flip (,) Cmd.none

    --Decrease ->
    --  { model | amount = model.amount - 1 }
    --  |>flip (,) Cmd.none




