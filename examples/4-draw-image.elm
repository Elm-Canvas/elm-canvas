module Main exposing (..)

import Html exposing (..)
import Canvas exposing (Size, Error, Point, DrawOp(..), DrawImageParams(..), Canvas)
import Color
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
    = ImageLoaded (Result Error Canvas)
    | Blit MouseEvent


type Model
    = GotCanvas Canvas (List DrawOp)
    | Loading


loadImage : Cmd Msg
loadImage =
    Task.attempt
        ImageLoaded
        (Canvas.loadImage "./steelix.png")



-- UPDATE --



update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case (message, model ) of
        (ImageLoaded (Ok canvas), _ ) ->
            (GotCanvas canvas [], Cmd.none)

        (Blit mouseEvent, GotCanvas canvas drawOps) ->
            let
                newDrawOps =
                    blit 
                        (toPoint mouseEvent)
                        canvas
                        drawOps
            in
                ( GotCanvas canvas newDrawOps, Cmd.none)

        _ ->
            (Loading, loadImage)


toPoint : MouseEvent -> Point
toPoint { targetPos, clientPos } =
    Point
        (toFloat (clientPos.x - targetPos.x))
        (toFloat (clientPos.y - targetPos.y))


blit : Point -> Canvas -> List DrawOp -> List DrawOp
blit point canvas drawOps =
    let
        scaling : DrawImageParams
        scaling =
            Scaled point (Size 64 64)

        newestOp = 
            DrawImage canvas scaling
    in
        newestOp :: (List.take 199 drawOps)



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

        GotCanvas canvas drawOps ->
            div 
                []
                [ Canvas.initialize (Size 800 800)
                    |> Canvas.draw (DrawImage canvas (At (Point 0 0)))
                    |> Canvas.toHtml 
                        [ MouseEvents.onMouseMove Blit ]
                ]

