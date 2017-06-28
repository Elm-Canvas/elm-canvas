module Main exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Canvas exposing (Canvas, Point, Size, DrawOp(..))
import Time exposing (Time)
import Color exposing (Color)
import Random exposing (Generator)
import AnimationFrame


main =
    Html.program
        { init = ( initModel, initCmd )
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT --


dotsGenerator : Generator (List Dot)
dotsGenerator =
    let
        pointGenerator : Generator Point
        pointGenerator =
            Random.map2 Point
                (Random.float 0 (toFloat canvasSize.width))
                (Random.float 0 (toFloat canvasSize.height))

        velocityGenerator : Generator Point
        velocityGenerator =
            Random.map2 Point
                (Random.float -maxSpeed maxSpeed)
                (Random.float -maxSpeed maxSpeed)

        colorGenerator : Generator Color
        colorGenerator =
            Random.map4 Color.rgba
                (Random.int 20 255)
                (Random.int 20 255)
                (Random.int 20 255)
                (Random.float 1 1)

        dotGenerator : Generator Dot
        dotGenerator =
            Random.map3 Dot
                pointGenerator
                velocityGenerator
                colorGenerator
    in
        Random.list 100 dotGenerator


initCmd : Cmd Msg
initCmd =
    Random.generate GetDots dotsGenerator


initModel : Model
initModel =
    { canvas =
        Canvas.initialize canvasSize
    , dots = []
    }



-- CONFIG --


canvasSize : Size
canvasSize =
    Size 800 800


maxSpeed : Float
maxSpeed =
    400


dotSize : Float
dotSize =
    2.0



-- TYPES --


type alias Model =
    { canvas : Canvas
    , dots : List Dot
    }


type alias Dot =
    { point : Point
    , velocity : Point
    , color : Color
    }


type Msg
    = Tick Time
    | GetDots (List Dot)



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetDots dots ->
            { model | dots = dots } ! []

        Tick dt ->
            let
                dt_ =
                    dt / 1000

                newDots =
                    List.map (updateDot dt_) model.dots

                drawOp =
                    Canvas.batch
                        [ fade dt_
                        , drawDots newDots
                        ]
            in
                { model
                    | canvas =
                        Canvas.draw drawOp model.canvas
                    , dots = newDots
                }
                    ! []


updateDot : Time -> Dot -> Dot
updateDot dt ({ point, velocity } as dot) =
    let
        x =
            point.x + (dt * velocity.x)

        y =
            point.y + (dt * velocity.y)

        newVx =
            let
                tooFarLeft =
                    x < 0

                tooFarRight =
                    (toFloat canvasSize.width) < x
            in
                if tooFarLeft || tooFarRight then
                    velocity.x * -0.9
                else
                    velocity.x

        newVy =
            let
                tooLow =
                    y < 0

                tooHigh =
                    (toFloat canvasSize.height) < y
            in
                if tooLow || tooHigh then
                    (velocity.y * -0.9) + 0.5
                else
                    velocity.y + 0.5

        newVelocity =
            { x = newVx
            , y = newVy
            }

        newPoint =
            { x =
                max 0 (min (toFloat canvasSize.width) x)
            , y =
                max 0 (min (toFloat canvasSize.height) y)
            }
    in
        { dot
            | point = newPoint
            , velocity = newVelocity
        }



-- DRAW --


drawDots : List Dot -> DrawOp
drawDots dots =
    Canvas.batch (List.map drawDot dots)


drawDot : Dot -> DrawOp
drawDot { point, color } =
    let
        x =
            point.x - (dotSize / 2)

        y =
            point.y - (dotSize / 2)
    in
        [ BeginPath
        , FillStyle color
        , Rect
            (Point x y)
            (Size (round dotSize) (round dotSize))
        , Fill
        ]
            |> Canvas.batch


fade : Time -> DrawOp
fade dt =
    [ BeginPath
    , FillStyle (Color.rgba 255 255 255 (0.5 * dt))
    , Rect (Point 0 0) canvasSize
    , Fill
    ]
        |> Canvas.batch



-- VIEW --


view : Model -> Html Msg
view model =
    div
        []
        [ Canvas.toHtml
            [ style
                [ ( "border", "2px solid #000" )
                , ( "margin", "0 auto" )
                , ( "margin-top", "10px" )
                , ( "display", "block" )
                ]
            ]
            model.canvas
        ]



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ AnimationFrame.diffs Tick ]
