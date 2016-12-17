module View exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import Components       exposing (..)
import List             exposing (repeat, map, concat)
import Array            exposing (Array, toIndexedList)
import Canvas


view : Model -> Html Msg
view model =
  div
  [ class "root" ]
  [ div 
    [ style [ ("display", "inline-block") ] ] 
    [ ignorablePoint "Elm Canvas!" 
    , clickablePoint "Add Canvas" AddCanvas
    ]
  , div 
    [ ]
    (canvases model.canvases)
  ]


canvases : Array Canvas -> List (Html Msg)
canvases canvases' =
  canvases'
  |>toIndexedList
  |>map canvasView


canvasView : (Int, Canvas) -> Html Msg
canvasView (index, cv) =
  let 
    {width, height, numberOfViews} = cv 
    data = getData cv
  in
  div 
  [ class "canvas-container"
  , style [ ("width", (toString width)) ] 
  ]
  <|concat
  [ map optionRow
    [ [ point "Width" 
      , clickablePoint "+" (IncreaseWidth index)
      , clickablePoint "-" (DecreaseWidth index)
      ]
    , [ point "Height" 
      , clickablePoint "+" (IncreaseHeight index)
      , clickablePoint "-" (DecreaseHeight index)
      ]
    , [ point "Views"
      , clickablePoint "+" (AddView index)
      , clickablePoint "-" (RemoveView index)
      ]
    , [ point "Red" 
      , clickablePoint "+" (IncreaseRed index)
      , clickablePoint "-" (DecreaseRed index)
      ]
    , [ point "Green" 
      , clickablePoint "+" (IncreaseGreen index)
      , clickablePoint "-" (DecreaseGreen index)
      ]
    , [ point "Blue" 
      , clickablePoint "+" (IncreaseBlue index)
      , clickablePoint "-" (DecreaseBlue index)
      ]
    , [ point "Gradient"
      , clickablePoint "Switch" (SwitchGradient index)
      ]
    ]
  , repeat numberOfViews
    <|Canvas.canvas 
        [ id (toString index) ] 
        width
        height 
        data
  ]

getData : Canvas -> List Int
getData {width, height, color, gradient} =
  let 
    pixels =
      let 
        (r, g, b) = color
        dataSize  = width * height 
      in
      if gradient then
        map 
          (\a -> [ r, g, b, a % 256 ])
          [ 0 .. dataSize ]
      else
        repeat dataSize [ r, g, b, 255]
  in
  concat pixels



