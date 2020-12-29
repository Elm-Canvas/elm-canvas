module Main exposing (..)

import AnimationFrame
import Canvas exposing (Canvas, Point, Size)
import Color exposing (Color)
import Ctx exposing (Ctx, Style(Color))
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
            ( { model | dots = dots }, Cmd.none )

        Tick dt ->
            ( updateCanvas (dt / 1000) model
            , Cmd.none
            )


updateCanvas : Time -> Model -> Model
updateCanvas dt model =
    let
        newDots =
            List.map (updateDot dt) model.dots
    in
    { model
        | canvas =
            Ctx.draw
                model.canvas
                (mainCtx dt newDots)
        , dots = newDots
    }



-- DRAW --


mainCtx : Time -> List Dot -> List Ctx
mainCtx dt dots =
    [ fade dt
    , dotsCtx (List.map (updateDot dt) dots)
    ]


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


dotsCtx : List Dot -> Ctx
dotsCtx dots =
    Ctx.batch (List.map dotCtx dots)


dotCtx : Dot -> Ctx
dotCtx { point, color } =
    [ Ctx.beginPath
    , Ctx.fillStyle <| Color color
    , Ctx.rect
        { x = point.x - (dotSize / 2)
        , y = point.y - (dotSize / 2)
        }
        { width = round dotSize
        , height = round dotSize
        }
    , Ctx.fill
    ]
        |> Ctx.batch


fade : Time -> Ctx
fade dt =
    [ Ctx.beginPath
    , Ctx.fillStyle <| Color (Color.rgba 255 255 255 (0.5 * dt))
    , Ctx.rect { x = 0, y = 0 } canvasSize
    , Ctx.fill
    ]
        |> Ctx.batch



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
    AnimationFrame.diffs Tick
