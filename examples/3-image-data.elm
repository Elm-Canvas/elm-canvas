module Main exposing (..)

import Html exposing (..)
import Html.Events as Events
import Canvas exposing (Size, Error, DrawOp(..), Canvas)
import Canvas.Point exposing (Point)
import Canvas.Point as Point
import Array exposing (Array)
import Task


main =
    Html.program
        { init = ( Loading, loadImage )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- TYPES


type Msg
    = ImageLoaded (Result Error Canvas)
    | Click


type Model
    = GotCanvas Canvas
    | Loading


loadImage : Cmd Msg
loadImage =
    Task.attempt
        ImageLoaded
        (Canvas.loadImage "./steelix.png")



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ImageLoaded result ->
            case Result.toMaybe result of
                Just canvas ->
                    ( GotCanvas canvas, Cmd.none )

                Nothing ->
                    ( Loading, loadImage )

        Click ->
            case model of
                Loading ->
                    ( Loading, loadImage )

                GotCanvas canvas ->
                    ( GotCanvas (invert canvas), Cmd.none )


invert : Canvas -> Canvas
invert canvas =
    Canvas.batch
        [ PutImageData
            (invertedImageData canvas)
            (Canvas.getSize canvas)
            (Point.fromInts ( 0, 0 ))
        ]
        canvas


invertedImageData : Canvas -> Array Int
invertedImageData =
    Canvas.getImageData >> Array.indexedMap invertHelp


invertHelp : Int -> Int -> Int
invertHelp index color =
    if index % 4 == 3 then
        color
    else
        255 - color



-- VIEW


view : Model -> Html Msg
view model =
    div
        []
        [ p [] [ text "Click to invert colors" ]
        , presentIfReady model
        ]


presentIfReady : Model -> Html Msg
presentIfReady model =
    case model of
        Loading ->
            p [] [ text "Loading image" ]

        GotCanvas canvas ->
            Canvas.toHtml
                [ Events.onClick Click ]
                canvas
