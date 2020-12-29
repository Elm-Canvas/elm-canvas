module Util
    exposing
        ( toPoint
        )

import Canvas exposing (Point)
import MouseEvents exposing (MouseEvent)


toPoint : MouseEvent -> Point
toPoint { targetPos, clientPos } =
    { x = toFloat (clientPos.x - targetPos.x)
    , y = toFloat (clientPos.y - targetPos.y)
    }
