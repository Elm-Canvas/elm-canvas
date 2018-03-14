module Main exposing (..)

import Canvas exposing (Canvas, DrawOp(..), Point, Size)
import Color exposing (Color)
import Html exposing (Attribute, Html)
import Html.Attributes exposing (style)
import MouseEvents exposing (MouseEvent)


-- MAIN --


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model =
            ( Canvas.initialize (Size 800 800)
            , NoClick
            )
        , view = view
        , update = update
        }


type ClickState
    = NoClick
    | Click Point
    | Moving Point Point


type Msg
    = MouseDown MouseEvent
    | Move MouseEvent


type alias Model =
    ( Canvas, ClickState )



-- UPDATE --


update : Msg -> Model -> Model
update msg ( canvas, clickState ) =
    case ( clickState, msg ) of
        ( NoClick, MouseDown mouseEvent ) ->
            ( canvas, Click (toPoint mouseEvent) )

        ( Moving pt0 pt1, MouseDown mouseEvent ) ->
            ( drawLine pt0 pt1 canvas, NoClick )

        ( Click point, Move mouseEvent ) ->
            ( canvas, Moving point (toPoint mouseEvent) )

        ( Moving point0 _, Move mouseEvent ) ->
            ( canvas, Moving point0 (toPoint mouseEvent) )

        _ ->
            ( canvas, clickState )


toPoint : MouseEvent -> Point
toPoint { targetPos, clientPos } =
    { x = toFloat (clientPos.x - targetPos.x)
    , y = toFloat (clientPos.y - targetPos.y)
    }



-- VIEW --


view : Model -> Html Msg
view model =
    Canvas.toHtml
        [ style [ ( "border", "4px solid black" ) ]
        , MouseEvents.onMouseDown MouseDown
        , MouseEvents.onMouseMove Move
        ]
        (handleClickState model)


handleClickState : Model -> Canvas
handleClickState ( canvas, clickState ) =
    case clickState of
        Moving pt0 pt1 ->
            drawLine pt0 pt1 canvas

        _ ->
            canvas


drawLine : Point -> Point -> Canvas -> Canvas
drawLine pt0 pt1 =
    [ BeginPath
    , LineWidth 30
    , LineCap "round"
    , MoveTo pt0
    , LineTo pt1
    , Stroke
    ]
        |> Canvas.batch
        |> Canvas.draw
