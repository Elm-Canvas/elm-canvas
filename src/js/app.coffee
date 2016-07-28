_         = require 'lodash'
app       = Elm.Main.fullscreen()
{draw} = app.ports

draw.subscribe (thing) ->

  blue = [ 0, 255, 255, 255 ]

  ctx =
    document.getElementById "number-1-canvas"
    .getContext '2d'

  img = ctx.createImageData 50, 50
  
  _.forEach img.data, (d, i) ->
    img.data[i] = blue[i % 4]

  ctx.putImageData img, 10, 10


  
