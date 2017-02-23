module Main exposing (..)

import Html exposing (..)
import Canvas.Events as Events
import Canvas exposing (Size, DrawOp(..), Error, Canvas)
import Canvas.Point exposing (Point)
import Canvas.Point as Point
import Canvas.Pixel as Pixel
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
    = Loaded Canvas (Maybe ( Point, Color ))
    | Loading


loadImage : Cmd Msg
loadImage =
    Task.attempt
        ImageLoaded
        (Canvas.loadImage "./arizona.jpg")



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ImageLoaded result ->
            case Result.toMaybe result of
                Just canvas ->
                    ( Loaded canvas Nothing, Cmd.none )

                Nothing ->
                    ( Loading, loadImage )

        Move point ->
            case model of
                Loading ->
                    ( Loading, loadImage )

                Loaded canvas _ ->
                    let
                        pixel =
                            Pixel.get point canvas
                    in
                        ( Loaded canvas (Just ( point, pixel ))
                        , Cmd.none
                        )



-- VIEW


view : Model -> Html Msg
view model =
    div
        []
        [ p [] [ text "Mouse over pixels to enlarge them" ]
        , presentIfReady model
        ]


presentIfReady : Model -> Html Msg
presentIfReady model =
    case model of
        Loading ->
            p [] [ text "Loading image" ]

        Loaded canvas maybePixel ->
            Canvas.toHtml
                [ Events.onMouseMove Move ]
                (drawPatch canvas maybePixel)


drawPatch : Canvas -> Maybe ( Point, Color ) -> Canvas
drawPatch canvas maybePixel =
    case maybePixel of
        Nothing ->
            canvas

        Just ( point, color ) ->
            Canvas.batch
                [ BeginPath
                , Rect point (Size 100 100)
                , FillStyle color
                , Fill
                , BeginPath
                , Rect point (Size 100 100)
                , StrokeStyle Color.red
                , Stroke
                ]
                canvas
