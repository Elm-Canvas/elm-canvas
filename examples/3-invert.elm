module Main exposing (..)

import Array exposing (Array)
import Canvas exposing (Canvas, Error, Point, Size)
import Ctx exposing (Ctx)
import Html exposing (Html, p, text)
import Html.Events as Events
import Task


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
    | Click


type Model
    = Loaded Canvas
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
            ( Loaded canvas, Cmd.none )

        ( Click, Loaded canvas ) ->
            ( Loaded (invert canvas), Cmd.none )

        _ ->
            ( Loading, loadImage )


invert : Canvas -> Canvas
invert canvas =
    Ctx.draw canvas [ invertCtx canvas ]


invertCtx : Canvas -> Ctx
invertCtx canvas =
    Ctx.putImageData
        (invertedImageData canvas)
        (Canvas.getSize canvas)
        { x = 0, y = 0 }


invertedImageData : Canvas -> List Int
invertedImageData canvas =
    canvas
        |> Canvas.getImageData
            { x = 0, y = 0 }
            (Canvas.getSize canvas)
        |> List.indexedMap invertHelp


invertHelp : Int -> Int -> Int
invertHelp index color =
    if index % 4 == 3 then
        color
    else
        255 - color



-- VIEW --


view : Model -> Html Msg
view model =
    case model of
        Loading ->
            p [] [ text "Loading image" ]

        Loaded canvas ->
            Canvas.toHtml
                [ Events.onClick Click ]
                canvas
