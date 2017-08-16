module Main exposing (..)

import Html exposing (..)
import Canvas exposing (Size, Error, Point, DrawOp(..), Canvas)
import MouseEvents exposing (MouseEvent)
import Task
import Color


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
    = ImageLoaded (Result Error Canvas)
    | Move MouseEvent


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
    case ( message, model ) of
        ( ImageLoaded (Ok canvas), _ ) ->
            ( GotCanvas canvas (Point 0 0), Cmd.none )

        ( Move mouseEvent, GotCanvas canvas _ ) ->
            ( GotCanvas canvas (toPoint mouseEvent), Cmd.none )

        _ ->
            ( Loading, loadImage )


toPoint : MouseEvent -> Point
toPoint { targetPos, clientPos } =
    Point
        (toFloat (clientPos.x - targetPos.x))
        (toFloat (clientPos.y - targetPos.y))



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

        GotCanvas canvas point ->
            let
                size =
                    Canvas.getSize canvas
            in
                canvas
                    |> Canvas.draw (drawSquare point size)
                    |> Canvas.toHtml
                        [ MouseEvents.onMouseMove Move ]


drawSquare : Point -> Size -> DrawOp
drawSquare point size =
    [ StrokeStyle Color.red
    , LineWidth 15
    , StrokeRect point (calcSize point size)
    ]
        |> Canvas.batch


calcSize : Point -> Size -> Size
calcSize { x, y } { width, height } =
    Size
        (width - 2 * (floor x))
        (height - 2 * (floor y))
