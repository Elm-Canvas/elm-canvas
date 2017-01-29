module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (type_, value, style)
import Html.Events exposing (onClick)
import Canvas exposing (Canvas, Position, Size)
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
    { show : Bool, canvas : Canvas }


type Msg
    = Draw Position
    | ShowSwitch


init : Model
init =
    Size 400 300
        |> Canvas.initialize
        |> Canvas.fill Color.black
        |> Model True


blueSquare : Canvas
blueSquare =
    Size 30 30
        |> Canvas.initialize
        |> Canvas.fill Color.blue



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update message { show, canvas } =
    case message of
        Draw position ->
            let
                updatedCanvas =
                    putBlueSquare position canvas
            in
                ( Model show updatedCanvas, Cmd.none )

        ShowSwitch ->
            ( Model (not show) canvas, Cmd.none )


putBlueSquare : Position -> Canvas -> Canvas
putBlueSquare =
    Canvas.drawCanvas blueSquare



-- VIEW


view : Model -> Html Msg
view model =
    div
        []
        [ p
            []
            [ text "Elm-Canvas" ]
        , input
            [ type_ "submit"
            , value "show / hide"
            , onClick ShowSwitch
            ]
            []
        , div
            []
            [ canvasView model ]
        ]


canvasView : Model -> Html Msg
canvasView { canvas, show } =
    if show then
        Canvas.toHtml
            [ Canvas.onMouseDown Draw
            , style
                [ ( "border", "1px solid #000000" )
                , ( "cursor", "crosshair" )
                ]
            ]
            canvas
    else
        text ""
