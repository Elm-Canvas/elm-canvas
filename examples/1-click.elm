module Main exposing (..)

import Html exposing (p, text, div, Html, Attribute)
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


init : Canvas
init =
    Canvas.initialize (Size 500 400)
        |> Canvas.fill Color.black



-- TYPES


type Msg
    = Draw Position



-- UPDATE


update : Msg -> Canvas -> ( Canvas, Cmd Msg )
update message canvas =
    case message of
        Draw position ->
            ( addWhitePixel position canvas, Cmd.none )


addWhitePixel : Position -> Canvas -> Canvas
addWhitePixel =
    Canvas.setPixel Color.white



-- VIEW


view : Canvas -> Html Msg
view canvas =
    div
        []
        [ p [] [ text "Elm-Canvas" ]
        , Canvas.toHtml
            [ Canvas.onMouseDown Draw
            , style [ ( "cursor", "crosshair" ) ]
            ]
            canvas
        ]
