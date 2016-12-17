import Html             exposing (p, text)
import Html.Attributes  exposing (class)
import List             exposing (repeat)
import Array            exposing (Array, fromList, push, get, set)
import Types            exposing (..)
import View             exposing (view)
import Maybe            exposing (withDefault)


(.) = flip 

initCanvas : Canvas
initCanvas =
  { width         = 256
  , height        = 256
  , color         = (128, 128, 128)
  , numberOfViews = 1
  , gradient      = False
  } 

initModel : Model
initModel =
  { canvases = 
      fromList [ initCanvas ]
  }

main =
  Html.program
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
      |>(,) . Cmd.none

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

    IncreaseHeight index ->
      let {canvases} = model in
      updateCanvas index canvases increaseHeight
      |>update . model

    DecreaseHeight index ->
      let {canvases} = model in
      updateCanvas index canvases decreaseHeight
      |>update . model

    AddView index ->
      let {canvases} = model in
      updateCanvas index canvases addView
      |>update . model

    RemoveView index ->
      let {canvases} = model in
      updateCanvas index canvases removeView
      |>update . model

    IncreaseRed index ->
      let {canvases} = model in
      updateCanvas index canvases increaseRed
      |>update . model

    DecreaseRed index ->
      let {canvases} = model in
      updateCanvas index canvases decreaseRed
      |>update . model

    IncreaseGreen index ->
      let {canvases} = model in
      updateCanvas index canvases increaseGreen
      |>update . model

    DecreaseGreen index ->
      let {canvases} = model in
      updateCanvas index canvases decreaseGreen
      |>update . model

    IncreaseBlue index ->
      let {canvases} = model in
      updateCanvas index canvases increaseBlue
      |>update . model

    DecreaseBlue index ->
      let {canvases} = model in
      updateCanvas index canvases decreaseBlue
      |>update . model

    SwitchGradient index ->
      let {canvases} = model in
      updateCanvas index canvases switchGradient
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

switchGradient : Canvas -> Canvas
switchGradient canvas =
  { canvas
  | gradient = not canvas.gradient
  }

decreaseRed : Canvas -> Canvas
decreaseRed canvas =
  let (r,g,b) = canvas.color in
  { canvas
  | color =  (r - 30, g, b)
  }

increaseRed : Canvas -> Canvas
increaseRed canvas =
  let (r,g,b) = canvas.color in
  { canvas
  | color =  (r + 1, g, b)
  }

decreaseGreen : Canvas -> Canvas
decreaseGreen canvas =
  let (r,g,b) = canvas.color in
  { canvas
  | color =  (r, g - 1, b)
  }

increaseGreen : Canvas -> Canvas
increaseGreen canvas =
  let (r,g,b) = canvas.color in
  { canvas
  | color =  (r, g + 1, b)
  }

decreaseBlue : Canvas -> Canvas
decreaseBlue canvas =
  let (r,g,b) = canvas.color in
  { canvas
  | color =  (r, g, b - 1)
  }

increaseBlue : Canvas -> Canvas
increaseBlue canvas =
  let (r,g,b) = canvas.color in
  { canvas
  | color =  (r, g, b + 1)
  }

addView : Canvas -> Canvas
addView canvas =
  { canvas
  | numberOfViews = canvas.numberOfViews + 1
  }

removeView : Canvas -> Canvas
removeView canvas =
  { canvas
  | numberOfViews = canvas.numberOfViews - 1
  }

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

decreaseHeight : Canvas -> Canvas
decreaseHeight canvas =
  { canvas
  | height = canvas.height - 1
  } 

increaseHeight : Canvas -> Canvas
increaseHeight canvas =
  { canvas
  | height = canvas.height + 1
  }


