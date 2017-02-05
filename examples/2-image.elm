module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style)
import Canvas exposing (Size, Position, Error, DrawOp(..), Canvas)
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
    | Move Position


type Model
    = GotCanvas Canvas Position
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
                    ( GotCanvas canvas (Position 0 0), Cmd.none )

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
    div []
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


drawSquare : Position -> Canvas -> Canvas
drawSquare { x, y } canvas =
    let
        { width, height } =
            Canvas.getSize canvas
    in
        Canvas.batch
            [ StrokeStyle Color.red
            , LineWidth 15
            , StrokeRect
                (Position x y)
                (Size (width - 2 * x) (height - 2 * y))
            ]
            canvas
