module Main exposing (..)

import Html exposing (..)
import Canvas exposing (Size, Position, Error, DrawOp(..), DrawImageOp(..), Canvas)
import Canvas.Events
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
    | Blit Position


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
                            [ DrawImage canvas (Scale position (Size 64 64))
                            ]
                    in
                        ( GotCanvas canvas (List.append drawOps additionalDrawOps)
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
            Canvas.toHtml
                [ Canvas.Events.onMouseDown Blit ]
                (drawScaledImages drawOps canvas)


drawScaledImages : List DrawOp -> Canvas -> Canvas
drawScaledImages drawOps canvas =
    let
        { width, height } =
            Canvas.getSize canvas
    in
        Canvas.batch drawOps canvas
