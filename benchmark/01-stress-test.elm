module Main exposing (..)

import Html exposing (Html, div, button, text, ol, li)
import Html.Events exposing (onClick)
import Color
import Random
import Task
import Date exposing (Date)
import Platform.Cmd exposing (Cmd)

import Canvas exposing (Canvas, Position, Size)


-- Constants

numberOfRects : Int
numberOfRects = 1000

resolution : ( Int, Int )
resolution = ( 800, 600 )


-- Main


main =
  Html.program
    { init = ( init, Cmd.none )
    , view = view
    , update = update
    , subscriptions = always Sub.none
    }


-- Types


type alias Model =
  { canvas : Canvas
  , testStartedAt : Float
  , remainingRects : Int
  , deltas : List Float
  , testResults : List Float
  , axisGenerator: Random.Generator ( Int, Int )
  , colorGenerator: Random.Generator ( Int, Int, Int )
  }


init : Model
init =
  let
    ( width, height ) = resolution

    canvas : Canvas
    canvas =
      Size width height
        |> Canvas.initialize

  in
    { canvas = canvas
    , testStartedAt = 0.0
    , remainingRects = numberOfRects
    , deltas = []
    , testResults = []
    , axisGenerator = Random.pair (Random.int 1 (width // 2)) (Random.int 1 (height // 2))
    , colorGenerator = Random.map3 (,,) (Random.int 0 255) (Random.int 0 255) (Random.int 0 255)
    }


-- Update


type Msg
  = TestBegin
  | TestEnd
  | DeltaBegin Date
  | DeltaEnd Date
  | RandomPosition ( Int, Int )
  | RandomSize ( Int, Int ) ( Int, Int )
  | CreateRectangle ( Int, Int ) ( Int, Int ) ( Int, Int, Int )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  let
    newRectCmd : Cmd Msg
    newRectCmd = Random.generate RandomPosition model.axisGenerator

  in
    case msg of
      TestBegin ->
        let
          ( width, height ) = resolution

          canvas : Canvas
          canvas =
            Size width height
              |> Canvas.initialize

        in
          ( { model |
              canvas = canvas
            , remainingRects = numberOfRects
            }
          , Task.perform DeltaBegin Date.now
          )


      TestEnd ->
        let
          deltasLength : Float
          deltasLength =
            toFloat (List.length model.deltas)

          average : Float
          average =
            model.deltas
              |> List.sum

          testResults : List Float
          testResults =
            List.append model.testResults [average / deltasLength]

        in
          ( { model |
              testResults = testResults
            , deltas = []
            }
          , Cmd.none
          )


      DeltaBegin now ->
        ( { model | testStartedAt = Date.toTime now }
        , newRectCmd
        )


      DeltaEnd now ->
        let
          testEndedAt : Float
          testEndedAt =
            Date.toTime now

          deltas : List Float
          deltas =
            model.deltas
              |> List.append [(testEndedAt - model.testStartedAt)]

        in
          update TestEnd { model | deltas = deltas }


      RandomPosition position ->
        ( model
        , Random.generate (RandomSize position) model.axisGenerator
        )


      RandomSize position size ->
        ( model
        , Random.generate (CreateRectangle position size) model.colorGenerator
        )


      CreateRectangle ( x, y ) ( width, height ) ( red, blue, green ) ->
        if model.remainingRects > 0 then
          let
            myRect : Canvas
            myRect =
              Size width height
                |> Canvas.initialize
                |> Canvas.fill (Color.rgb red blue green)

            canvas : Canvas
            canvas =
              model.canvas
                |> Canvas.drawCanvas myRect (Position x y)

          in
            if model.remainingRects > 1 then
              ( { model |
                  remainingRects = model.remainingRects - 1
                , canvas = canvas
                }
              , newRectCmd
              )

            else
              ( model
              , Task.perform DeltaEnd Date.now
              )

        else
          ( model
          , Cmd.none
          )


-- View


view : Model -> Html Msg
view model =
  let
    ( width, height ) = resolution

    result : Float -> Html Msg
    result pastResult =
      li [] [ text ("run took " ++ (toString pastResult) ++ "ms") ]

    pastResults : Html Msg
    pastResults =
      ol
        []
        ( List.map result model.testResults )

    averageRunTimes : Html Msg
    averageRunTimes =
      let
        totalPastResults : Float
        totalPastResults =
          List.sum model.testResults

        averageResults : Float
        averageResults =
          totalPastResults / (toFloat (List.length model.testResults))

      in
        if (List.length model.testResults) > 0 then
          div [] [ text ("Average run time of " ++ (toString averageResults) ++ "ms") ]
        else
          div [] [ text "Run some benchmarks to build up an average run time" ]

  in
    div
      []
      [ div [] [ text ("Average time to render " ++ (toString numberOfRects) ++ " opaque rectangles on a " ++ (toString width) ++ "x" ++ (toString height) ++ " canvas") ]
      , div
        []
        [ button
          [ onClick TestBegin ]
          [ text "Begin benchmark" ]
        ]
      , Canvas.toHtml [] model.canvas
      , averageRunTimes
      , pastResults
      ]
