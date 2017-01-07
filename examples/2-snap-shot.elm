import Html exposing (..)
import Html.Attributes exposing (style, type_, value)
import Html.Events exposing (onClick)
import Canvas exposing (ImageData, Pixel, Position)
import Dict exposing (Dict)
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
  Dict String ImageData


type Msg
  = Draw String Position
  | TakeSnapshot


blankCanvas : ImageData
blankCanvas =
  Canvas.blank 400 300 Color.black


init : Model
init =
  Dict.fromList
  [ ("main", blankCanvas)
  , ("snapshot", blankCanvas)
  ]



-- UPDATE



update :  Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of 

    Draw id position ->
      let 
        imageData = 
          Pixel Color.blue position
          |>Canvas.setPixel id
          |>Maybe.withDefault blankCanvas
      in
      (Dict.insert id imageData model, Cmd.none)

    TakeSnapshot ->
      let
        setSnapshot =
          let
            putMainCanvas =
              Canvas.get "main" 
              |>Maybe.withDefault blankCanvas
              |>Canvas.put
          in 
            putMainCanvas Canvas.origin "snapshot"
            |>Maybe.withDefault blankCanvas
            |>Dict.insert "snapshot"
      in
        (setSnapshot model, Cmd.none)



-- VIEW



view : Model -> Html Msg
view model =
  div 
  [] 
  [ input 
    [ type_ "submit"
    , value "take snapshot" 
    , onClick TakeSnapshot
    ] []
  , div [] <| List.map canvasView (Dict.toList model)
  ]


canvasView : (String, ImageData) -> Html Msg
canvasView (id, imageData) =
  let {width, height} = imageData in
  div
  []
  [ p [] [ text id ] 
  , Canvas.toHtml id imageData 
    [ onMouseDown id 
    , Canvas.size (width, height)
    ]
  ]


onMouseDown : String -> Attribute Msg
onMouseDown id =
  Canvas.onMouseDown (Draw id)


