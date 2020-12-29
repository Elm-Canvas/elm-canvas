module Main exposing (..)

import Canvas exposing (Canvas, Error, Point, Size)
import Color
import Ctx exposing (Ctx)
import Html exposing (Html, p, text)
import Html.Attributes exposing (style)
import MouseEvents exposing (MouseEvent)
import Task
import Util


main : Program Never Model Msg
main =
    Html.program
        { init = ( Loading, loadImage )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- TYPES --


type Msg
    = CanvasLoaded (Result Error Canvas)
    | MouseMoved MouseEvent


type Model
    = Loaded Canvas (List Ctx)
    | Loading


loadImage : Cmd Msg
loadImage =
    "./steelix.png"
        |> Canvas.loadImage
        |> Task.attempt CanvasLoaded



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( CanvasLoaded (Ok canvas), _ ) ->
            ( Loaded (scaleDown canvas) [], Cmd.none )

        ( MouseMoved mouseEvent, Loaded canvas drawOps ) ->
            ( blit mouseEvent canvas drawOps
                |> Loaded canvas
            , Cmd.none
            )

        _ ->
            ( Loading, loadImage )


scaleDown : Canvas -> Canvas
scaleDown canvas =
    canvas
        |> scaleDownCtx
        |> Ctx.draw
            (Canvas.initialize { width = 300, height = 300 })


scaleDownCtx : Canvas -> List Ctx
scaleDownCtx canvas =
    [ Ctx.drawImageScaled
        canvas
        { x = 0, y = 0 }
        { width = 300, height = 300 }
    ]


blit : MouseEvent -> Canvas -> List Ctx -> List Ctx
blit mouseEvent canvas ctx =
    mouseEvent
        |> Util.toPoint
        |> center
        |> Ctx.drawImage canvas
        |> withRest ctx


withRest : List Ctx -> Ctx -> List Ctx
withRest rest ctx =
    ctx :: List.take 199 rest


center : Point -> Point
center { x, y } =
    { x = x - 150, y = y - 150 }



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        Loading ->
            p [] [ text "Loading image" ]

        Loaded canvas ctx ->
            Canvas.toHtml
                [ MouseEvents.onMouseMove MouseMoved
                , style [ ( "border", "2px solid #000000" ) ]
                ]
                (canvasFromCtx ctx)


canvasFromCtx : List Ctx -> Canvas
canvasFromCtx =
    { width = 800, height = 800 }
        |> Canvas.initialize
        |> Ctx.draw
