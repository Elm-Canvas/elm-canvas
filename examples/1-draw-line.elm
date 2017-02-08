module Main exposing (..)

import Html exposing (Html, Attribute)
import Html.Attributes exposing (style)
import Canvas exposing (Size, Point, Cap(..), DrawOp(..), Canvas)
import Canvas.Events
import Color exposing (Color)


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
    = Nothing
    | FirstClick Point
    | Moving Point Point


type Msg
    = Click Point
    | Move Point


type alias Model =
    ( Canvas, ClickState )


update : Msg -> Model -> Model
update message ( canvas, clickState ) =
    case message of
        Click point ->
            case clickState of
                Nothing ->
                    ( canvas, FirstClick point )

                FirstClick p1 ->
                    ( canvas, clickState )

                Moving p0 p1 ->
                    ( drawLine p0 p1 canvas, Nothing )

        Move point ->
            case clickState of
                Nothing ->
                    ( canvas, Nothing )

                FirstClick p0 ->
                    ( canvas, Moving p0 point )

                Moving p0 _ ->
                    ( canvas, Moving p0 point )


view : Model -> Html Msg
view model =
    Canvas.toHtml
        [ style
            [ ( "border", "4px solid black" ) ]
        , Canvas.Events.onMouseDown Click
        , Canvas.Events.onMouseMove Move
        ]
        (handleClickState model)


handleClickState : Model -> Canvas
handleClickState ( canvas, clickState ) =
    case clickState of
        Moving p0 p1 ->
            drawLine p0 p1 canvas

        _ ->
            canvas


drawLine : Point -> Point -> Canvas -> Canvas
drawLine p0 p1 =
    Canvas.batch
        [ BeginPath
        , LineWidth 30
        , LineCap Round
        , MoveTo p0
        , LineTo p1
        , Stroke
        ]
