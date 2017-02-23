module Canvas.Point
    exposing
        ( Point
        , fromFloats
        , fromInts
        , toFloats
        , toInts
        )


type Point
    = Floats Float Float
    | Ints Int Int


fromFloats : ( Float, Float ) -> Point
fromFloats ( f0, f1 ) =
    Floats f0 f1


fromInts : ( Int, Int ) -> Point
fromInts ( i0, i1 ) =
    Ints i0 i1


toFloats : Point -> ( Float, Float )
toFloats point =
    case point of
        Floats f0 f1 ->
            ( f0, f1 )

        Ints i0 i1 ->
            ( toFloat i0, toFloat i1 )


toInts : Point -> ( Int, Int )
toInts point =
    case point of
        Floats f0 f1 ->
            ( floor f0, floor f1 )

        Ints i0 i1 ->
            ( i0, i1 )
