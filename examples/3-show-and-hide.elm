import Html exposing (..)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onClick)
import Canvas exposing (ImageData, Position)
import Color


main = 
  Html.program
  { init  = (init, Cmd.none) 
  , view   = view 
  , update = update
  , subscriptions = always Sub.none
  }



-- TYPES



type alias Model = 
  { show : Bool
  , imageData : (String, ImageData)
  }


type Msg
  = Draw Position
  | ShowSwitch


blankCanvas : ImageData
blankCanvas =
  Canvas.blank 400 300 Color.black


init : Model
init =
  Model True ("the-canvas", blankCanvas)


blueSquare : ImageData
blueSquare =
  Canvas.blank 20 20 Color.blue



-- UPDATE



update :  Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of 

    Draw position ->
      let 
        newImageData =
          let (id, imageData) = model.imageData in
          (id, (putBlueSquare position id))
      in
      ({ model | imageData = newImageData}, Cmd.none)

    ShowSwitch ->
      ({ model | show = not model.show }, Cmd.none)


putBlueSquare : Position -> String -> ImageData
putBlueSquare position id =
  Canvas.put blueSquare position id
  |>Maybe.withDefault blankCanvas




-- VIEW



view : Model -> Html Msg
view model =
  let (id, imageData) = model.imageData in
  if model.show then
    let {width, height} = imageData in
    container
    [ Canvas.toHtml id imageData 
      [ Canvas.onMouseDown Draw
      , Canvas.size (width, height)
      ]
    ]
  else
    container []


container : List (Html Msg) -> Html Msg
container canvas =
  div
  []
  [ input 
    [ type_ "submit"
    , value "show / hide" 
    , onClick ShowSwitch
    ] []
  , div [] canvas
  ]




