module Main exposing (..)

import AnimationFrame
import Canvas exposing (Canvas, DrawOp(..), Point, Size, Style(Color))
import Color exposing (Color)
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Random exposing (Generator)
import Time exposing (Time)


main =
    Html.program
        { init = ( initModel, initCmd )
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT --


initCmd : Cmd Msg
initCmd =
    Random.generate GetDots dotsGenerator


initModel : Model
initModel =
    { canvas = Canvas.initialize canvasSize
    , dots = []
    }


dotsGenerator : Generator (List Dot)
dotsGenerator =
    Random.list 100 dotGenerator


dotGenerator : Generator Dot
dotGenerator =
    Random.map3 Dot
        pointGenerator
        velocityGenerator
        colorGenerator


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
            in
            { model
                | canvas =
                    Canvas.draw
                        (mainOp dt_ newDots)
                        model.canvas
                , dots = newDots
            }
                ! []


mainOp : Time -> List Dot -> DrawOp
mainOp dt dots =
    [ fade dt
    , dotsOp (List.map (updateDot dt) dots)
    ]
        |> Canvas.batch


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
                    toFloat canvasSize.width < x
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
                    toFloat canvasSize.height < y
            in
            if tooLow || tooHigh then
                (velocity.y * -0.9) + 0.5
            else
                velocity.y + 0.5
    in
    { dot
        | point =
            { x =
                max 0 (min (toFloat canvasSize.width) x)
            , y =
                max 0 (min (toFloat canvasSize.height) y)
            }
        , velocity = { x = newVx, y = newVy }
    }



-- DRAW --


dotsOp : List Dot -> DrawOp
dotsOp dots =
    Canvas.batch (List.map dotOp dots)


dotOp : Dot -> DrawOp
dotOp { point, color } =
    [ BeginPath
    , FillStyle <| Color color
    , Rect
        { x = point.x - (dotSize / 2)
        , y = point.y - (dotSize / 2)
        }
        { width = round dotSize
        , height = round dotSize
        }
    , Fill
    ]
        |> Canvas.batch


fade : Time -> DrawOp
fade dt =
    [ BeginPath
    , FillStyle <| Color (Color.rgba 255 255 255 (0.5 * dt))
    , Rect (Point 0 0) canvasSize
    , Fill
    ]
        |> Canvas.batch



-- VIEW --


view : Model -> Html Msg
view model =
    Canvas.toHtml
        [ style
            [ ( "border", "2px solid #000" )
            , ( "margin", "0 auto" )
            , ( "margin-top", "10px" )
            , ( "display", "block" )
            ]
        ]
        model.canvas



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ AnimationFrame.diffs Tick ]
