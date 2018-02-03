module Main exposing (..)

import Html exposing (..)
import Canvas exposing (Size, Error, Point, DrawOp(..), Canvas, Style(..), Repeat(Repeat), ColorStop)
import MouseEvents exposing (MouseEvent)
import Task
import Color


main : Program Never Model Msg
main =
    Html.program
        { init = ( Loading, loadImages )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- TYPES


type Msg
    = ImageLoaded (Result Error (Canvas, Canvas))
    | Move MouseEvent


type Model
    = GotCanvas Canvas Canvas Point
    | Loading


loadImages : Cmd Msg
loadImages =
    Task.attempt
        ImageLoaded
        <| Task.map2 (,)
          (Canvas.loadImage "./steelix.png")
          (Canvas.loadImage "./sand.png")




-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case ( message, model ) of
        ( ImageLoaded (Ok (canvas, texture)), _ ) ->
            ( GotCanvas canvas texture (Point 0 0), Cmd.none )

        ( Move mouseEvent, GotCanvas canvas texture _ ) ->
            ( GotCanvas canvas texture (toPoint mouseEvent), Cmd.none )

        _ ->
            ( Loading, loadImages )


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

        GotCanvas canvas pattern point ->
            let
                size =
                    Canvas.getSize canvas
            in
                canvas
                    |> Canvas.draw (drawSquare point size pattern)
                    |> Canvas.toHtml
                        [ MouseEvents.onMouseMove Move ]


drawSquare : Point -> Size -> Canvas -> DrawOp
drawSquare point size pattern =
  let
      grad = RadialGradient (Point 74 50) 5 (Point 90 60) 100 [(Canvas.ColorStop 0 Color.red), (Canvas.ColorStop 1 Color.orange)]
  in
    --[ StrokeStyle (Pattern pattern Repeat)
    [ StrokeStyle (grad)
    , LineWidth 15
    , StrokeRect point (calcSize point size)
    ]
        |> Canvas.batch


calcSize : Point -> Size -> Size
calcSize { x, y } { width, height } =
    Size
        (width - 2 * (floor x))
        (height - 2 * (floor y))
