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
            ( { width = 800, height = 800 }
                |> Canvas.initialize
                |> drawBackground
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

        ( Moving point _, Move mouseEvent ) ->
            ( canvas, Moving point (toPoint mouseEvent) )

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
        [ style
            [ ( "border", "4px solid black" ) ]
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


drawBackground : Canvas -> Canvas
drawBackground =
    [ BeginPath
    , rainbowFillStyle
    , FillRect (Point 0 0) (Size 800 800)
    , Fill
    ]
        |> Canvas.batch
        |> Canvas.draw


rainbowFillStyle : DrawOp
rainbowFillStyle =
    [ ( 1, Color.red )
    , ( 0.9, Color.orange )
    , ( 0.7, Color.yellow )
    , ( 0.5, Color.green )
    , ( 0.3, Color.blue )
    , ( 0.1, Color.purple )
    ]
        |> radial ( 400, 400 ) 0 ( 400, 400 ) 400
        |> Gradient
        |> FillStyle


drawLine : Point -> Point -> Canvas -> Canvas
drawLine pt0 pt1 =
    [ BeginPath
    , LineWidth 30
    , LineCap "round"
    , blackAndWhiteFillStyle pt0 pt1
    , MoveTo pt0
    , LineTo pt1
    , Stroke
    ]
        |> Canvas.batch
        |> Canvas.draw


blackAndWhiteFillStyle : Point -> Point -> DrawOp
blackAndWhiteFillStyle pt0 pt1 =
    [ ( 0, Color.white )
    , ( 1, Color.black )
    ]
        |> linear ( pt0.x, 0 ) ( pt1.x, 0 )
        |> Gradient
        |> StrokeStyle
