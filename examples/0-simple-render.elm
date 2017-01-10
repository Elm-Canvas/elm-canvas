import Html.Attributes exposing (style)
import Canvas exposing (Canvas)
import Color


main =
  Canvas.initialize 400 300
  |>Canvas.fill (Color.rgb 23 92 254)
  |>Canvas.toHtml []



