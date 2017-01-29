module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style, type_, value)
import Html.Events exposing (onClick)
import Canvas exposing (Canvas, Position, Image, Error, Size)
import Color
import Task


main =
    Html.program
        { init = ( init, initCmd )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- TYPES


type alias Model =
    { main : Canvas
    , crop : Canvas
    , image : Maybe Image
    }


type Msg
    = Draw Position
    | Crop
    | ImageLoaded (Result Error Image)



-- INIT


init : Model
init =
    Model
        (initializeBlack (Size 400 300))
        (initializeBlack redSquareSize)
        Nothing


redSquareSize : Size
redSquareSize =
    Size 100 100


redSquarePosition : Position
redSquarePosition =
    Position 150 100


redSquare : Canvas
redSquare =
    Canvas.drawRectangle
        redSquarePosition
        redSquareSize
        Color.red
        (Canvas.initialize (Size 400 300))


initializeBlack : Size -> Canvas
initializeBlack =
    Canvas.initialize >> Canvas.fill Color.black


initCmd : Cmd Msg
initCmd =
    Task.attempt
        ImageLoaded
        (Canvas.loadImage "./cia_head.png")



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Draw position ->
            case model.image of
                Just image ->
                    ( (draw position image model), Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        Crop ->
            ( crop model, Cmd.none )

        ImageLoaded result ->
            ( { model | image = Result.toMaybe result }, Cmd.none )


draw : Position -> Image -> Model -> Model
draw position img model =
    { model
        | main =
            Canvas.drawImage
                img
                (drawAt img position)
                model.main
    }


drawAt : Image -> Position -> Position
drawAt img position =
    let
        { width, height } =
            Canvas.getImageSize img
    in
        Position
            (position.x - (width // 2))
            (position.y - (height // 2))


crop : Model -> Model
crop model =
    { model
        | crop =
            Canvas.drawCanvas
                (cropRedSquare model.main)
                (Position 0 0)
                model.crop
    }


cropRedSquare : Canvas -> Canvas
cropRedSquare =
    Canvas.crop redSquarePosition redSquareSize



-- VIEW


view : Model -> Html Msg
view { main, crop } =
    div []
        [ input
            [ type_ "submit"
            , value "crop"
            , onClick Crop
            ]
            []
        , mainCanvasView main
        , p [] [ text "crop : " ]
        , div
            [ style [ ( "display", "block" ) ] ]
            [ Canvas.toHtml [] crop ]
        ]


mainCanvasView : Canvas -> Html Msg
mainCanvasView canvas =
    div
        [ style
            [ ( "position", "relative" )
            , ( "width", "400px" )
            , ( "height", "300px" )
            ]
        ]
        [ Canvas.toHtml
            [ style
                [ ( "position", "absolute" )
                , ( "left", "0px" )
                , ( "top", "0px" )
                ]
            ]
            canvas
        , Canvas.toHtml
            [ Canvas.onMouseMove Draw
            , style
                [ ( "cursor", "crosshair" )
                , ( "position", "absolute" )
                , ( "left", "0px" )
                , ( "top", "0px" )
                ]
            ]
            redSquare
        ]
