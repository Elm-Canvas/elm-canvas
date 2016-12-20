_      = require 'lodash'
app    = Elm.Main.fullscreen()

# {populate} = app.ports

app.ports.populate.subscribe (id) ->
  canvas = document.getElementById id
  ctx = canvas.getContext '2d'

  imageData = ctx.createImageData 400, 400
  data = imageData.data

  _.times (400 * 400), (i) ->
    i_ = i * 4
    data[ i_     ] = 0
    data[ i_ + 1 ] = 0
    data[ i_ + 2 ] = 0
    data[ i_ + 3 ] = 255 

  ctx.putImageData imageData, 0, 0

  # console.log 'DANK', canvas