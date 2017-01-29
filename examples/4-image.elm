module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onClick)
import Canvas exposing (Canvas, Position, Image, Error, Size)
import Task
import Color


main =
    Html.program
        { init = ( Loading, loadImage )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- TYPES


type Msg
    = Draw Position
    | ImageLoaded (Result Error Image)


type Model
    = GotCanvas Canvas
    | Loading


loadImage : Cmd Msg
loadImage =
    Task.attempt ImageLoaded (Canvas.loadImage "./steelix.png")


redSquare : Canvas
redSquare =
    Size 30 30
        |> Canvas.initialize
        |> Canvas.fill Color.red



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case model of
        Loading ->
            case message of
                ImageLoaded result ->
                    result
                        |> Result.toMaybe
                        |> handleImageResult

                _ ->
                    ( model, Cmd.none )

        GotCanvas canvas ->
            case message of
                Draw position ->
                    ( GotCanvas (draw position canvas), Cmd.none )

                _ ->
                    ( model, Cmd.none )


draw : Position -> Canvas -> Canvas
draw =
    Canvas.drawCanvas redSquare


handleImageResult : Maybe Image -> ( Model, Cmd Msg )
handleImageResult result =
    case result of
        Just image ->
            ( GotCanvas (Canvas.fromImage image), Cmd.none )

        Nothing ->
            ( Loading, loadImage )



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

        GotCanvas canvas ->
            Canvas.toHtml
                [ Canvas.onMouseDown Draw ]
                canvas
