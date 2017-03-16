module Main exposing (..)

import Html exposing (Html, div, button, text, table, thead, tr, th, tbody, td)
import Html.Attributes exposing (disabled, style)
import Html.Events exposing (onClick)
import Color exposing (Color)
import Random
import Task
import Date exposing (Date)
import Time exposing (Time)



-- Constants


numberOfRects : Int
numberOfRects =
    500


resolution : Size
resolution =
    Size 800 600


rectSize : Size
rectSize =
    Size 100 100



-- Main


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- Types


type alias Model =
    { canvas : Canvas
    , testStartedAt : Float
    , rectangleDrawTimes : List Float
    , rectangles : List Rectangle
    , results : List TestResult



type alias Rectangle =
    { position : Position
    , size : Size
    , color : Color
    }


type alias TestResult =
    { index : String
    , fastest : Float
    , slowest : Float
    , average : Float
    , totalTime : Float
    }


init : ( Model, Cmd Msg )
init =
    let
        canvas : Canvas
        canvas =
            Size resolution.width resolution.height
                |> Canvas.initialize


        )


defaultRect : Rectangle
defaultRect =
    Rectangle
        (Position 0 0)
        rectSize
        (Color.rgb 0 0 0)



-- Update


type Msg
    = Benchmark
 Rectangle) Float Float


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Benchmark ->
            ( model
            , Task.perform TestBegin Time.now
            )

        TestBegin timestamp ->
            let
                canvas : Canvas
                canvas =
                    Size resolution.width resolution.height
                        |> Canvas.initialize
            in
                ( { model
                    | canvas = canvas
                    , testStartedAt = timestamp
                    , rectangleDrawTimes = []
                  }
                , Task.perform (RenderBegin model.rectangles) Time.now
                )

        TestEnd timestamp ->
            let
                result : TestResult
                result =
                    let
                        fastest : Float
                        fastest =
                            Maybe.withDefault 0 (List.minimum model.rectangleDrawTimes)

                        slowest : Float
                        slowest =
                            Maybe.withDefault 1 (List.maximum model.rectangleDrawTimes)

                        average : Float
                        average =
                            model.rectangleDrawTimes
                                |> List.sum
                                |> (\sum -> sum / (toFloat (List.length model.rectangleDrawTimes)))

                        totalTime : Float
                        totalTime =
                            timestamp - model.testStartedAt
                    in
                        { index = toString ((List.length model.results) + 1)
                        , fastest = fastest
                        , slowest = slowest
                        , average = average
                        , totalTime = totalTime
            rectangle =
                    rectangles
                        |> List.head
                        |> Maybe.withDefault defaultRect

                newRectangles : List Rectangle
                newRectangles =
                    rectangles
                        |> List.tail
                        |> Maybe.withDefault []
            in
                ( { model | canvas = canvas }
                , Task.perform (RenderEnd newRectangles timestamp) Time.now
                )

        RenderEnd rectangles beginTimestamp timestamp ->
            let
                delta : Float
                delta =
                    timestamp - beginTimestamp

                rectangleDrawTimes : List Float
                rectangleDrawTimes =
                    List.append model.rectangleDrawTimes [ delta ]

                command : Cmd Msg
                command =
                    if (List.length rectangles) > 0 then
                        Task.perform (RenderBegin rectangles) Time.now
                    else
                        Task.perform TestEnd Time.now
            in
                ( { model | rectangleDrawTimes = rectangleDrawTimes }
                , command
                )



-- View


view : Model -> Html Msg
view model =
    let
        resultsHtml : List TestResult -> Html Msg
        resultsHtml results =
            let
                msToString : Float -> String
                msToString milliseconds =
                    (toString milliseconds) ++ "ms"

                tdStyles : List ( String, String )
                tdStyles =
                    [ ( "border-top", "1px black solid" )
                    , ( "text-align", "center" )
                    ]

                tdAttributes : List (Html.Attribute Msg)
                tdAttributes =
                    [ style tdStyles
                    ]

                renderRow : TestResult -> Html Msg
                renderRow result =
                    tr
                        []
                        [ td
                            [ style [ ( "border-top", "1px black solid" ) ] ]
                            [ text (result.index ++ ".") ]
                        , td tdAttributes [ text (msToString result.fastest) ]
                        , td tdAttributes [ text (msToString result.slowest) ]
                        , td tdAttributes [ text (msToString result.average) ]
                        , td tdAttributes [ text (msToString result.totalTime) ]
                        ]

                thStyle : List ( String, String )
                thStyle =
                    [ ( "width", "100px" )
                    ]
            in
                if (List.length results) > 0 then
                    table
                        [ style
                            [ ( "border-collapse", "collapse" )
                            ]
                        ]
                        [ thead
                            []
                            [ tr
                                []
                                [ th [ style thStyle ] [ text "" ]
                                , th [ style thStyle ] [ text "Fastest" ]
                                , th [ style thStyle ] [ text "Slowest" ]
                                , th [ style thStyle ] [ text "Average" ]
                                , th [ style thStyle ] [ text "Total time" ]
                                ]
                            ]
                        , tbody
                            []
                            (List.map renderRow results)
                        ]
                else
                    text ""

        averageResult : TestResult
        averageResult =
            { index = "Average"
            , fastest = Maybe.withDefault -1 <| List.minimum <| List.map .fastest model.results
     List.append model.results [ averageResult ]
            else
                model.results

        buttonDisabled : Bool
        buttonDisabled =
            (List.length model.rectangles) < numberOfRects

        buttonText : String
        buttonText =
            if buttonDisabled then
                "Preloading rectangle data..."
            else
                "Begin benchmark"
    in
        div
            []
            [ div
                []
                [ text
                    ("Average time to render "
                        ++ (toString numberOfRects)
                        ++ " opaque rectangles on a "
                        ++ (toString resolution.width)
                        ++ "x"
                        ++ (toString resolution.height)
                        ++ " canvas"
                    )
                ]
            , div
                []
                [ button
                    [ onClick Benchmark
                    , disabled buttonDisabled
                    ]
                    [ text buttonText ]
                ]
            , Canvas.toHtml [] model.canvas
            , resultsHtml allResults
            ]
