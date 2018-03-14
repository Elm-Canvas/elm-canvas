module Main exposing (..)

import Canvas exposing (Canvas, Error, Point, Size)
import Color
import Ctx exposing (Ctx)
import Html exposing (Html, p, text)
import MouseEvents exposing (MouseEvent)
import Task


main : Program Never Model Msg
main =
    Html.program
        { init = ( Loading, loadImage )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- TYPES


type Msg
    = CanvasLoaded (Result Error Canvas)
    | Move MouseEvent


type Model
    = Loaded Canvas Point
    | Loading


loadImage : Cmd Msg
loadImage =
    "./steelix.png"
        |> Canvas.loadImage
        |> Task.attempt CanvasLoaded



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( CanvasLoaded (Ok canvas), _ ) ->
            ( Loaded canvas { x = 0, y = 0 }, Cmd.none )

        ( Move mouseEvent, Loaded canvas _ ) ->
            ( Loaded canvas (toPoint mouseEvent), Cmd.none )

        _ ->
            ( Loading, loadImage )


toPoint : MouseEvent -> Point
toPoint { targetPos, clientPos } =
    { x = toFloat (clientPos.x - targetPos.x)
    , y = toFloat (clientPos.y - targetPos.y)
    }



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        Loading ->
            p [] [ text "Loading image" ]

        Loaded canvas point ->
            Canvas.toHtml
                [ MouseEvents.onMouseMove Move ]
                (drawSquare point canvas)


drawSquare : Point -> Canvas -> Canvas
drawSquare point canvas =
    canvas
        |> Canvas.getSize
        |> square point
        |> Ctx.draw canvas


square : Point -> Size -> List Ctx
square point size =
    [ Ctx.strokeStyle <| Ctx.Color Color.red
    , Ctx.lineWidth 15
    , Ctx.strokeRect point (calcSize point size)
    ]


calcSize : Point -> Size -> Size
calcSize { x, y } { width, height } =
    { width = width - 2 * floor x
    , height = height - 2 * floor y
    }
