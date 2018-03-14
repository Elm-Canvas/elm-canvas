module Main exposing (..)

import Canvas exposing (Canvas, DrawImageParams(..), DrawOp(..), Error, Point, Size)
import Color
import Html exposing (Html, p, text)
import Html.Attributes exposing (style)
import MouseEvents exposing (MouseEvent)
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
    = CanvasLoaded (Result Error Canvas)
    | MouseMoved MouseEvent


type Model
    = Loaded Canvas (List DrawOp)
    | Loading


loadImage : Cmd Msg
loadImage =
    "./steelix.png"
        |> Canvas.loadImage
        |> Task.attempt CanvasLoaded



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( CanvasLoaded (Ok canvas), _ ) ->
            ( Loaded (scaleDown canvas) [], Cmd.none )

        ( MouseMoved mouseEvent, Loaded canvas drawOps ) ->
            ( blit mouseEvent canvas drawOps
                |> Loaded canvas
            , Cmd.none
            )

        _ ->
            ( Loading, loadImage )


scaleDown : Canvas -> Canvas
scaleDown canvas =
    { width = 300, height = 300 }
        |> Canvas.initialize
        |> Canvas.draw (scaleDownOp canvas)


scaleDownOp : Canvas -> DrawOp
scaleDownOp canvas =
    Scaled
        { x = 0, y = 0 }
        { width = 300, height = 300 }
        |> DrawImage canvas


toPoint : MouseEvent -> Point
toPoint { targetPos, clientPos } =
    { x = toFloat (clientPos.x - targetPos.x)
    , y = toFloat (clientPos.y - targetPos.y)
    }


blit : MouseEvent -> Canvas -> List DrawOp -> List DrawOp
blit mouseEvent canvas drawOps =
    mouseEvent
        |> toPoint
        |> center
        |> At
        |> DrawImage canvas
        |> withRest drawOps


withRest : List DrawOp -> DrawOp -> List DrawOp
withRest rest drawOp =
    drawOp :: List.take 199 rest


center : Point -> Point
center { x, y } =
    { x = x - 150, y = y - 150 }



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        Loading ->
            p [] [ text "Loading image" ]

        Loaded canvas drawOps ->
            Canvas.initialize (Size 800 800)
                |> Canvas.draw (Canvas.batch drawOps)
                |> Canvas.toHtml
                    [ MouseEvents.onMouseMove MouseMoved
                    , style [ ( "border", "2px solid #000000" ) ]
                    ]
