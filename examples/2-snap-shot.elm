module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style, type_, value)
import Html.Events exposing (onClick)
import Canvas exposing (Canvas, Position, Size)
import Dict exposing (Dict)
import Color


main =
    Html.program
        { init = ( init, Cmd.none )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- TYPES


type alias Model =
    ( Canvas, Canvas )


type Msg
    = Draw Position
    | TakeSnapshot


init : Model
init =
    let
        size =
            Size 400 300
    in
        ( initializeBlack size, initializeBlack size )


initializeBlack : Size -> Canvas
initializeBlack =
    Canvas.initialize >> Canvas.fill Color.black



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update message ( main, snapshot ) =
    case message of
        Draw position ->
            ( ( putWhitePixel position main, snapshot ), Cmd.none )

        TakeSnapshot ->
            ( ( main, main ), Cmd.none )


putWhitePixel : Position -> Canvas -> Canvas
putWhitePixel =
    Canvas.setPixel Color.white



-- VIEW


view : Model -> Html Msg
view ( main, snapshot ) =
    div
        []
        [ input
            [ type_ "submit"
            , value "take snapshot"
            , onClick TakeSnapshot
            ]
            []
        , canvasView
            [ Canvas.onMouseDown Draw
            , style [ ( "cursor", "crosshair" ) ]
            ]
            main
        , p
            []
            [ text "snapshot : " ]
        , canvasView
            []
            snapshot
        ]


canvasView : List (Attribute Msg) -> Canvas -> Html Msg
canvasView attributes canvas =
    div
        []
        [ Canvas.toHtml attributes canvas ]
