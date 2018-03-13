module Main exposing (..)

import Canvas exposing (Canvas, DrawOp(..), Point, Size, Style(Gradient))
import Color exposing (Color, linear, radial)
import Html exposing (Attribute, Html)
import Html.Attributes exposing (style)
import MouseEvents exposing (MouseEvent)


-- MAIN --


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model =
            ( drawBackground <| Canvas.initialize (Size 800 800)
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


drawBackground : Canvas -> Canvas
drawBackground =
    let
        colorStops =
            [ ( 1, Color.red )
            , ( 0.9, Color.orange )
            , ( 0.7, Color.yellow )
            , ( 0.5, Color.green )
            , ( 0.3, Color.blue )
            , ( 0.1, Color.purple )
            ]

        gradient =
            radial ( 400, 400 ) 0 ( 400, 400 ) 400 colorStops
    in
    [ BeginPath
    , FillStyle (Gradient gradient)
    , FillRect (Point 0 0) (Size 800 800)
    , Fill
    ]
        |> Canvas.batch
        |> Canvas.draw


drawLine : Point -> Point -> Canvas -> Canvas
drawLine pt0 pt1 =
    let
        colorStops =
            [ ( 0, Color.white )
            , ( 1, Color.black )
            ]

        gradient =
            linear ( pt0.x, 0 ) ( pt1.x, 0 ) colorStops
    in
    [ BeginPath
    , LineWidth 30
    , LineCap "round"
    , StrokeStyle (Gradient gradient)
    , MoveTo pt0
    , LineTo pt1
    , Stroke
    ]
        |> Canvas.batch
        |> Canvas.draw
