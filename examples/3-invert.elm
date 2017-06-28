module Main exposing (..)

import Html exposing (..)
import Html.Events as Events
import Canvas exposing (Size, Error, Point, DrawOp(..), Canvas)
import Array exposing (Array)
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



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case ( message, model ) of
        ( ImageLoaded (Ok canvas), _ ) ->
            ( GotCanvas canvas, Cmd.none )

        ( Click, GotCanvas canvas ) ->
            ( GotCanvas (invert canvas), Cmd.none )

        _ ->
            ( Loading, loadImage )


invert : Canvas -> Canvas
invert canvas =
    let
        drawOp =
            PutImageData
                (invertedImageData canvas)
                (Canvas.getSize canvas)
                (Point 0 0)
    in
        Canvas.draw drawOp canvas


invertedImageData : Canvas -> List Int
invertedImageData canvas =
    let
        point =
            Point 0 0

        size =
            Canvas.getSize canvas
    in
        canvas
            |> Canvas.getImageData point size
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
