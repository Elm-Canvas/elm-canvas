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
import Canvas exposing (Position)
import Json.Decode as Json


{-| Just like the `onMouseDown` in `Html.Events`, but this one passes along a `Position` that is relative to the `Canvas`. So clicking right in the middle of a 200x200 `Canvas` will return a `Position` == `{x = 100, y = 100}`.
    case message of
      CanvasClick position ->
        -- ..
-}
onMouseDown : (Position -> msg) -> Attribute msg
onMouseDown message =
    on "mousedown" <|
        Json.map
            (positionInCanvas >> message)
            positionDecoder


{-| -}
onMouseUp : (Position -> msg) -> Attribute msg
onMouseUp message =
    on "mouseup" <|
        Json.map
            (positionInCanvas >> message)
            positionDecoder


{-| -}
onMouseMove : (Position -> msg) -> Attribute msg
onMouseMove message =
    on "mousemove" <|
        Json.map
            (positionInCanvas >> message)
            positionDecoder


{-| -}
onClick : (Position -> msg) -> Attribute msg
onClick message =
    on "click" <|
        Json.map
            (positionInCanvas >> message)
            positionDecoder


{-| -}
onDoubleClick : (Position -> msg) -> Attribute msg
onDoubleClick message =
    on "dblclick" <|
        Json.map
            (positionInCanvas >> message)
            positionDecoder


positionInCanvas : ( Position, Position ) -> Position
positionInCanvas ( client, offset ) =
    Position (client.x - offset.x) (client.y - offset.y)


positionDecoder : Json.Decoder ( Position, Position )
positionDecoder =
    Json.at [ "target" ] (toPosition "offsetLeft" "offsetTop")
        |> Json.map2 (,) (toPosition "clientX" "clientY")


toPosition : String -> String -> Json.Decoder Position
toPosition x y =
    Json.map2 Position (field_ x) (field_ y)


field_ : String -> Json.Decoder Int
field_ key =
    Json.field key Json.int
