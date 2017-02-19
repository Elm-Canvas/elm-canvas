module Canvas.Events
    exposing
        ( onMouseDown
        , onMouseUp
        , onMouseMove
        , onClick
        , onDoubleClick
        )

import Html exposing (Attribute)
import Html.Events exposing (on)
import Canvas exposing (Point)
import Json.Decode as Json


{-| Just like the `onMouseDown` in `Html.Events`, but this one passes along a `Point` that is relative to the `Canvas`. So clicking right in the middle of a 200x200 `Canvas` will return a `Point` == `{x = 100, y = 100}`.
    case message of
      CanvasClick position ->
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


positionInCanvas : ( Point, Point ) -> Point
positionInCanvas ( client, offset ) =
    Point (client.x - offset.x) (client.y - offset.y)


positionDecoder : Json.Decoder ( Point, Point )
positionDecoder =
    Json.at [ "target" ] (toPoint "offsetLeft" "offsetTop")
        |> Json.map2 (,) (toPoint "clientX" "clientY")


toPoint : String -> String -> Json.Decoder Point
toPoint x y =
    Json.map2 Point (field_ x) (field_ y)


field_ : String -> Json.Decoder Float
field_ key =
    Json.field key Json.float
