module Main exposing (..)

import Html exposing (p, text, div, Html)
import Html.Attributes exposing (style)
import Html.Events exposing (..)
import Canvas exposing (Canvas, Position, Size)
import Color exposing (Color)


main =
    Html.program
        { init = ( init, Cmd.none )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- TYPES


type alias Model =
    { move : Maybe Position
    , click : Maybe Position
    , canvas : Canvas
    }


init : Model
init =
    { move = Nothing
    , click = Nothing
    , canvas =
        Size 500 400
            |> Canvas.initialize
            |> Canvas.fill Color.black
    }


type Msg
    = MouseDown Position
    | MouseMove Position



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        MouseDown position0 ->
            case model.click of
                Just position1 ->
                    ( draw position0 position1 model, Cmd.none )

                Nothing ->
                    ( { model | click = Just position0 }, Cmd.none )

        MouseMove position ->
            ( { model | move = Just position }, Cmd.none )


draw : Position -> Position -> Model -> Model
draw p0 p1 model =
    { model
        | click = Nothing
        , canvas =
            Canvas.drawLine p0 p1 Color.blue model.canvas
    }



-- VIEW


view : Model -> Html Msg
view model =
    div
        []
        [ p [] [ text "Elm-Canvas" ]
        , Canvas.toHtml
            [ Canvas.onMouseDown MouseDown
            , Canvas.onMouseMove MouseMove
            , style
                [ ( "cursor", "crosshair" ) ]
            ]
            (renderCanvas model)
        ]


renderCanvas : Model -> Canvas
renderCanvas model =
    case model.move of
        Nothing ->
            model.canvas

        Just position0 ->
            case model.click of
                Nothing ->
                    model.canvas

                Just position1 ->
                    Canvas.drawLine
                        position0
                        position1
                        (Color.hsl 0 0.5 0.5)
                        model.canvas
