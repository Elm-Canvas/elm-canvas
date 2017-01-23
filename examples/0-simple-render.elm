import Canvas exposing (Canvas, Size)
import Color


main =
  Canvas.initialize (Size 400 300)
  |>Canvas.fill (Color.rgb 23 92 254)
  |>Canvas.toHtml []



