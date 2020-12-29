module Main exposing (..)

import Canvas exposing (Canvas, Point, Size)
import Color exposing (Color, linear, radial)
import Ctx exposing (Ctx, Style(Gradient))
import Html exposing (Attribute, Html)
import Html.Attributes exposing (style)
import MouseEvents exposing (MouseEvent)
import Util


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
            ( canvas, Click (Util.toPoint mouseEvent) )

        ( Moving pt0 pt1, MouseDown mouseEvent ) ->
            ( drawLine pt0 pt1 canvas, NoClick )

        ( Click point, Move mouseEvent ) ->
            ( canvas, Moving point (Util.toPoint mouseEvent) )

        ( Moving point _, Move mouseEvent ) ->
            ( canvas, Moving point (Util.toPoint mouseEvent) )

        _ ->
            ( canvas, clickState )



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
drawBackground canvas =
    [ Ctx.beginPath
    , rainbowFillStyle
    , Ctx.fillRect (Point 0 0) (Size 800 800)
    , Ctx.fill
    ]
        |> Ctx.draw canvas


rainbowFillStyle : Ctx
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
        |> Ctx.fillStyle


drawLine : Point -> Point -> Canvas -> Canvas
drawLine pt0 pt1 canvas =
    [ Ctx.beginPath
    , Ctx.lineWidth 30
    , Ctx.lineCap "round"
    , blackAndWhiteFillStyle pt0 pt1
    , Ctx.moveTo pt0
    , Ctx.lineTo pt1
    , Ctx.stroke
    ]
        |> Ctx.draw canvas


blackAndWhiteFillStyle : Point -> Point -> Ctx
blackAndWhiteFillStyle pt0 pt1 =
    [ ( 0, Color.white )
    , ( 1, Color.black )
    ]
        |> linear ( pt0.x, 0 ) ( pt1.x, 0 )
        |> Gradient
        |> Ctx.strokeStyle
