module Canvas.Point
    exposing
        ( Point
        , fromFloats
        , fromInts
        , toFloats
        , toInts
        )

{-| This module contains the union type `Point`, a type used in specifying exact positions within `Canvas`. It also exposes some functions that help convert `Point` to and from `(Int, Int)` or `(Float, Float)`. Making this its own module was a big step. We found that some canvas operations can utilize decimal places, and others absolutely cannot tolerate decimal places. Thus, a `Point` type that was either defined off `Int` or `Float`, would either be incapable of certain operations, or hazardously dangerous, depending on the application. Our solution was an opaque `Point` type, which must be constructed by deliberate reference to its input type.

@docs Point, fromFloats, fromInts, toFloats, toInts
-}


{-| -}
type Point
    = Floats Float Float
    | Ints Int Int


{-| -}
fromFloats : ( Float, Float ) -> Point
fromFloats ( f0, f1 ) =
    Floats f0 f1


{-| -}
fromInts : ( Int, Int ) -> Point
fromInts ( i0, i1 ) =
    Ints i0 i1


{-| -}
toFloats : Point -> ( Float, Float )
toFloats point =
    case point of
        Floats f0 f1 ->
            ( f0, f1 )

        Ints i0 i1 ->
            ( toFloat i0, toFloat i1 )


{-| -}
toInts : Point -> ( Int, Int )
toInts point =
    case point of
        Floats f0 f1 ->
            ( floor f0, floor f1 )

        Ints i0 i1 ->
            ( i0, i1 )
