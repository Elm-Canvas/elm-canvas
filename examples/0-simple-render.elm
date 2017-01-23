import Canvas
import Color


main =
  Canvas.initialize (Canvas.Size 400 300)
  |>Canvas.fill (Color.rgb 23 92 254)
  |>Canvas.toHtml []



