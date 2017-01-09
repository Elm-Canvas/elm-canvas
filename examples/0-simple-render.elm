import Html.Attributes exposing (style)
import Canvas exposing (Canvas)
import Color


main =
  Canvas.initialize 300 400
  |>Canvas.fill (Color.rgb 23 92 254)
  |>Canvas.toHtml []



