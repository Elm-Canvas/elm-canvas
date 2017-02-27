module Main exposing (..)

import Html exposing (..)
import Canvas exposing (Size, Error, DrawOp(..), Canvas)
import Canvas.Point exposing (Point)
import Canvas.Point as Point
import Canvas.Events
import Color exposing (Color)
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
    | Move Point


type Model
    = GotCanvas Canvas Point
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
                    ( GotCanvas canvas (Point.fromInts ( 0, 0 )), Cmd.none )

                Nothing ->
                    ( Loading, loadImage )

        Move position ->
            case model of
                Loading ->
                    ( Loading, loadImage )

                GotCanvas canvas _ ->
                    ( GotCanvas canvas position, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div
        []
        [ p [] [ text "Elm-Canvas" ]
        , presentIfReady model
        ]


presentIfReady : Model -> Html Msg
presentIfReady model =
    case model of
        Loading ->
            p [] [ text "Loading image" ]

        GotCanvas canvas position ->
            drawSquare position canvas
                |> Canvas.toHtml
                    [ Canvas.Events.onMouseMove Move ]


drawSquare : Point -> Canvas -> Canvas
drawSquare point canvas =
    Canvas.batch
        [ StrokeStyle Color.red
        , LineWidth 15
        , StrokeRect point <|
            calcSize point <|
                Canvas.getSize canvas
        ]
        canvas


calcSize : Point -> Size -> Size
calcSize point { width, height } =
    let
        ( x, y ) =
            Point.toInts point
    in
        Size
            (width - 2 * x)
            (height - 2 * y)
