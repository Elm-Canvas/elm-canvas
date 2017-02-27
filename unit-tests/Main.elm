import Expect
import Test exposing (..)
import Test.Runner.Html
import Canvas exposing (Canvas, Size)
import Array exposing (Array)

main : Test.Runner.Html.TestProgram
main =
    [ testToDataURL
    ]
      |> concat
      |> Test.Runner.Html.run


testToDataURL : Test
testToDataURL =
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
                in
                    Expect.equal (Canvas.getImageData canvas) expectation

        , test "A 5x5 empty canvas initializes properly" <|
            \() ->
                let
                    expectation : Array Int
                    expectation =
                        Array.repeat 100 0

                    canvas : Canvas
                    canvas =
                        Canvas.initialize (Size 5 5)
                in
                    Expect.equal (Canvas.getImageData canvas) expectation
        ]


