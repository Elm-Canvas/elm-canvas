module Main exposing (..)

import Html exposing (..)
import Canvas exposing (Size, Error, DrawOp(..), DrawImageParams(..), Canvas)
import Canvas.Point exposing (Point)
import Canvas.Point as Point
import Canvas.Events as Events
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
    | Blit Point


type Model
    = GotCanvas Canvas (List DrawOp)
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
                    ( GotCanvas canvas []
                    , Cmd.none
                    )

                Nothing ->
                    ( Loading
                    , loadImage
                    )

        Blit position ->
            case model of
                Loading ->
                    ( Loading
                    , loadImage
                    )

                GotCanvas canvas drawOps ->
                    let
                        additionalDrawOps : List DrawOp
                        additionalDrawOps =
                            [ DrawImage canvas (Scaled position (Size 64 64))
                            ]

                        newDrawOps : List DrawOp
                        newDrawOps =
                            if (List.length drawOps) > 200 then
                                List.drop 2 drawOps
                            else
                                drawOps
                    in
                        ( GotCanvas canvas (List.append newDrawOps additionalDrawOps)
                        , Cmd.none
                        )



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
            Canvas.initialize (Size 800 600)
                |> drawScaledImages drawOps
                |> Canvas.toHtml [ Events.onMouseMove Blit ]
                |> List.singleton
                |> div []


drawScaledImages : List DrawOp -> Canvas -> Canvas
drawScaledImages drawOps canvas =
    let
        { width, height } =
            Canvas.getSize canvas

        drawOpsWithBorder : List DrawOp
        drawOpsWithBorder =
            List.append
                drawOps
                [ BeginPath
                , StrokeStyle (Color.rgb 0 0 0)
                , LineWidth 2.0
                , Rect (Point.fromInts ( 0, 0 )) (Size 800 600)
                , Stroke
                ]
    in
        Canvas.batch drawOpsWithBorder canvas
