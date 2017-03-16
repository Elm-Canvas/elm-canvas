module Canvas.Events
    exposing
        ( onMouseDown
        , onMouseUp
        , onMouseMove
        , onClick
        , onDoubleClick
        )

{-| These functions are just like the `Html.Events` functions `onMouseDown`, `onMouseUp`, etc, except that they pass along a `Point`, representing exactly where on the canvas the mouse activity occured. They can be used on other elements too, like divs.

@docs onMouseDown, onMouseUp, onMouseMove, onClick, onDoubleClick
-}

import Html exposing (Attribute)
import Html.Events exposing (on)
import Canvas.Point exposing (Point)
import Canvas.Point as Point
import Json.Decode as Json


{-| Just like the `onMouseDown` in `Html.Events`, but this one passes along a `Point` that is relative to the `Canvas`. So clicking right in the middle of a 200x200 `Canvas` will return a `Point.toInts point == ( 100, 100 )`.

    Canvas.toHtml
        [ Canvas.Events.onClick CanvasClick ]
        canvas

    -- ..

    case message of
        CanvasClick point ->
            -- ..
-}
onMouseDown : (Point -> msg) -> Attribute msg
onMouseDown message =
    on "mousedown" <|
        Json.map
            (positionInCanvas >> message)
            positionDecoder


{-| -}
onMouseUp : (Point -> msg) -> Attribute msg
onMouseUp message =
    on "mouseup" <|
        Json.map
            (positionInCanvas >> message)
            positionDecoder


{-| -}
onMouseMove : (Point -> msg) -> Attribute msg
onMouseMove message =
    on "mousemove" <|
        Json.map
            (positionInCanvas >> message)
            positionDecoder


{-| -}
onClick : (Point -> msg) -> Attribute msg
onClick message =
    on "click" <|
        Json.map
            (positionInCanvas >> message)
            positionDecoder


{-| -}
onDoubleClick : (Point -> msg) -> Attribute msg
onDoubleClick message =
    on "dblclick" <|
        Json.map
            (positionInCanvas >> message)
            positionDecoder


positionInCanvas : ( ( Float, Float ), ( Float, Float ) ) -> Point
positionInCanvas ( client, offset ) =
    let
        ( cx, cy ) =
            client

        ( ox, oy ) =
            offset
    in
        Point.fromFloats ( cx - ox, cy - oy )


positionDecoder : Json.Decoder ( ( Float, Float ), ( Float, Float ) )
positionDecoder =
    Json.at [ "target" ] (toTuple "offsetLeft" "offsetTop")
        |> Json.map2 (,) (toTuple "clientX" "clientY")


toTuple : String -> String -> Json.Decoder ( Float, Float )
toTuple x y =
    Json.map2 (,) (field_ x) (field_ y)


field_ : String -> Json.Decoder Float
field_ key =
    Json.field key Json.float
