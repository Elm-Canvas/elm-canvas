module Main exposing (..)

import Html exposing (Html, Attribute)
import Html.Attributes exposing (style)
import Canvas exposing (Size, Point, DrawOp(..), Canvas, Style(..), ColorStop(..))
import Color exposing (Color)
import MouseEvents exposing (MouseEvent)


-- MAIN --


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model =
            ( Canvas.initialize (Size 800 800)
            , Nothing
            )
        , view = view
        , update = update
        }


type ClickState
    = Click Point
    | Moving Point Point


type Msg
    = MouseDown MouseEvent
    | Move MouseEvent


type alias Model =
    ( Canvas, Maybe ClickState )



-- UPDATE --


update : Msg -> Model -> Model
update message ( canvas, clickState ) =
    case ( clickState, message ) of
        ( Nothing, MouseDown mouseEvent ) ->
            ( canvas, Just (Click (toPoint mouseEvent)) )

        ( Just (Moving pt0 pt1), MouseDown mouseEvent ) ->
            ( drawLine pt0 pt1 canvas, Nothing )

        ( Just (Click point0), Move mouseEvent ) ->
            ( canvas, Just (Moving point0 (toPoint mouseEvent)) )

        ( Just (Moving point0 _), Move mouseEvent ) ->
            ( canvas, Just (Moving point0 (toPoint mouseEvent)) )

        _ ->
            ( canvas, clickState )


toPoint : MouseEvent -> Point
toPoint { targetPos, clientPos } =
    Point
        (toFloat (clientPos.x - targetPos.x))
        (toFloat (clientPos.y - targetPos.y))



-- VIEW --


view : Model -> Html Msg
view model =
    Canvas.toHtml
        [ style
            [ ( "border", "4px solid black" ) ]
        , MouseEvents.onMouseDown MouseDown
        , MouseEvents.onMouseMove Move
        ]
        (handleClickState model)


handleClickState : Model -> Canvas
handleClickState ( canvas, clickState ) =
    case clickState of
        Just (Moving pt0 pt1) ->
            drawLine pt0 pt1 canvas

        _ ->
            canvas


drawLine : Point -> Point -> Canvas -> Canvas
drawLine pt0 pt1 =
  let
    colorStops = [ ColorStop 0 Color.red
                 , ColorStop 0.3 Color.orange
                 , ColorStop 0.5 Color.yellow
                 , ColorStop 0.6 Color.green
                 , ColorStop 0.8 Color.blue
                 , ColorStop 1 Color.purple
                 ]
    gradient = LinearGradient (Point pt0.x 0) (Point pt1.x 0) colorStops
  in
    [ BeginPath
    , LineWidth 30
    , LineCap "round"
    , StrokeStyle gradient
    , MoveTo pt0
    , LineTo pt1
    , Stroke
    ]
        |> Canvas.batch
        |> Canvas.draw
