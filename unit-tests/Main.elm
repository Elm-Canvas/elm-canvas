import Expect
import Test exposing (..)
import Test.Runner.Html
import Canvas exposing (Canvas, Size)
import Canvas.Point exposing (Point)
import Array exposing (Array)

main : Test.Runner.Html.TestProgram
main =
    [ testInitializeGetImageData
    ]
      |> concat
      |> Test.Runner.Html.run


testInitializeGetImageData : Test
testInitializeGetImageData =
    describe "getImageData"
        [ test "A 1x1 empty canvas initializes properly" <|
            \() ->
                let
                    expectation : Array Int
                    expectation =
                        Array.repeat 4 0

                    canvas : Canvas
                    canvas =
                        Canvas.initialize (Size 1 1)

                    imageData : Array Int
                    imageData =
                        let
                            origin : Point
                            origin = Canvas.Point.fromInts ( 0, 0 )

                            size : Size
                            size = Canvas.getSize canvas
                        in
                            canvas
                                |> Canvas.getImageData origin size
                in
                    Expect.equal imageData expectation

        , test "A 5x5 empty canvas initializes properly" <|
            \() ->
                let
                    expectation : Array Int
                    expectation =
                        Array.repeat 100 0

                    canvas : Canvas
                    canvas =
                        Canvas.initialize (Size 5 5)

                    imageData : Array Int
                    imageData =
                        let
                            origin : Point
                            origin = Canvas.Point.fromInts ( 0, 0 )

                            size : Size
                            size = Canvas.getSize canvas
                        in
                            canvas
                                |> Canvas.getImageData origin size
                in
                    Expect.equal imageData expectation
        ]


