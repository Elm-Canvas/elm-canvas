module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style, type_, value)
import Html.Events exposing (onClick)
import Canvas exposing (Canvas, Position, Image, Error, Size)
import AnimationFrame exposing (diffs)
import Time exposing (Time)
import Color
import Task


main =
    Html.program
        { init = ( init, initCmd )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    diffs Tick



-- TYPES


type alias Model =
    { canvas : Canvas
    , image : Maybe Image
    , pendingDraw : Canvas -> Canvas
    }


type Msg
    = Draw Position
    | ImageLoaded (Result Error Image)
    | Tick Time


init : Model
init =
    Model
        (initializeBlack (Size 700 550))
        Nothing
        identity


initializeBlack : Size -> Canvas
initializeBlack =
    Canvas.initialize >> Canvas.fill Color.black


initCmd : Cmd Msg
initCmd =
    Task.attempt
        ImageLoaded
        (Canvas.loadImage "elm-logo.png")



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Draw pos ->
            case model.image of
                Just img ->
                    ( addDraw (draw img pos) model, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        ImageLoaded result ->
            ( { model | image = Result.toMaybe result }, Cmd.none )

        Tick _ ->
            ( applyDraw model, Cmd.none )


addDraw : (Canvas -> Canvas) -> Model -> Model
addDraw draw model =
    { model
        | pendingDraw = model.pendingDraw >> draw
    }


draw : Image -> Position -> Canvas -> Canvas
draw image position =
    Canvas.drawImage image (drawAt image position)


drawAt : Image -> Position -> Position
drawAt img position =
    let
        { width, height } =
            Canvas.getImageSize img
    in
        Position
            (position.x - (width // 2))
            (position.y - (height // 2))


applyDraw : Model -> Model
applyDraw model =
    { model
        | canvas =
            model.pendingDraw model.canvas
        , pendingDraw = identity
    }



-- VIEW


view : Model -> Html Msg
view { canvas } =
    div
        []
        [ Canvas.toHtml
            [ style [ ( "cursor", "crosshair" ) ]
            , Canvas.onMouseMove Draw
            ]
            canvas
        ]
