import Html exposing (Html, div, text)
import Random exposing (Generator)
import Time exposing (Time)
import Color exposing (Color)
import Canvas exposing (Canvas, Size, DrawOp(FillStyle, Rect, Fill, BeginPath))
import Canvas.Point exposing (Point)
import Canvas.Point as Point
import AnimationFrame


-- Config


resolution : Size
resolution =
    Size 800 600


numberOfDots : Int
numberOfDots =
    100


maxSpeed : Float
maxSpeed =
    50


dotSize : Float
dotSize =
    2.0


bounceFactor : Float
bounceFactor =
    -1.0


background : Color
background =
    Color.rgb 255 255 255


fadeFactor : Float
fadeFactor =
    8.0



-- Entry


main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- Model


type alias Model =
    { canvas : Canvas
    , dots : List Dot
    }


type alias Dot =
    { position : Point
    , velocity : Point
    , color : Color
    }


init : ( Model, Cmd Msg )
init =
    let
        toPoint : Float -> Float -> Point
        toPoint x y =
            Point.fromFloats ( x, y )

        positionGenerator : Generator Point
        positionGenerator =
            Random.map2 toPoint
                (Random.float 0 (toFloat resolution.width))
                (Random.float 0 (toFloat resolution.height))

        velocityGenerator : Generator Point
        velocityGenerator =
            Random.map2 toPoint
                (Random.float (-maxSpeed) maxSpeed)
                (Random.float (-maxSpeed) maxSpeed)

        colorGenerator : Generator Color
        colorGenerator =
            Random.map4 Color.rgba
                (Random.int 20 255)
                (Random.int 20 255)
                (Random.int 20 255)
                (Random.float 0.2 1.0)

        dotGenerator : Generator Dot
        dotGenerator =
            Random.map3 Dot
                positionGenerator
                velocityGenerator
                colorGenerator

        dotsGenerator : Generator (List Dot)
        dotsGenerator =
            Random.list numberOfDots dotGenerator
    in
        ( { canvas = Canvas.initialize resolution
          , dots = []
          }
        , Random.generate Begin dotsGenerator
        )



-- Update


type Msg
    = Begin (List Dot)
    | Delta Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Begin dots ->
            ( { model | dots = dots }
            , Cmd.none
            )

        Delta diff ->
            let
                size : Size
                size =
                    Canvas.getSize model.canvas

                delta : Float
                delta =
                    diff / 1000

                updateDot : Dot -> Dot
                updateDot dot =
                    let
                        ( px, py ) = Point.toFloats dot.position

                        ( vx, vy ) = Point.toFloats dot.velocity

                        positionInc : { x : Float, y : Float }
                        positionInc =
                            { x = px + (vx * delta)
                            , y = py + (vy * delta)
                            }

                        reverseX : Bool
                        reverseX =
                            (positionInc.x < 0)
                                || (positionInc.x > (toFloat resolution.width))

                        reverseY : Bool
                        reverseY =
                            (positionInc.y < 0)
                                || (positionInc.y > (toFloat resolution.height))

                        position : Point
                        position =
                            Point.fromFloats
                                ( min (max positionInc.x 0) (toFloat resolution.width)
                                , min (max positionInc.y 0) (toFloat resolution.height)
                                )

                        velocity : Point
                        velocity =
                            Point.fromFloats
                                ( vx
                                    * (if reverseX then
                                        bounceFactor
                                       else
                                        1.0
                                      )
                                , vy
                                    * (if reverseY then
                                        bounceFactor
                                       else
                                        1.0
                                      )
                                )
                    in
                        { dot
                        | position = position
                        , velocity = velocity
                        }

                fade : List DrawOp
                fade =
                    let
                        rgb : { red : Int, green : Int, blue : Int, alpha : Float }
                        rgb =
                            Color.toRgb background
                    in
                        [ BeginPath
                        , FillStyle (Color.rgba rgb.red rgb.green rgb.blue (fadeFactor * delta))
                        , Rect (Point.fromInts ( 0, 0 )) size
                        , Fill
                        ]

                dotDrawOps : List DrawOp
                dotDrawOps =
                    let
                        drawDot : Dot -> List DrawOp
                        drawDot dot =
                            let
                                ( originX, originY ) = Point.toFloats dot.position

                                halfSize : Float
                                halfSize =
                                    dotSize / 2
                            in
                                [ BeginPath
                                , FillStyle dot.color
                                , Rect
                                    (Point.fromFloats ( (originX - halfSize), (originY - halfSize)) )
                                    (Size (round dotSize) (round dotSize))
                                , Fill
                                ]
                    in
                        List.concatMap drawDot dots

                drawOps : List DrawOp
                drawOps =
                    fade ++ dotDrawOps

                canvas : Canvas
                canvas =
                    model.canvas
                        |> Canvas.batch drawOps

                dots : List Dot
                dots =
                    List.map updateDot model.dots
            in
                ( { model | canvas = canvas, dots = dots }
                , Cmd.none
                )



-- View


view : Model -> Html Msg
view model =
    div
        []
        [ Canvas.toHtml [] model.canvas
        ]



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ AnimationFrame.diffs Delta
        ]
