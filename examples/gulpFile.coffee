gulp       = require 'gulp'
autowatch  = require 'gulp-autowatch'
cp         = require 'child_process'
_          = require 'lodash'

elmExamples = [ 
    '0-simple-render',
    '1-click',
    '2-snap-shot',
    '3-show-and-hide',
    '4-image',
    '5-invert-image-data',
    '6-draw-line',
    '7-crop'
  ]

gulp.task 'elm', (a, b, c) ->  

  _.forEach elmExamples, (example) ->
    cmd  = 'elm-make ./' + example 
    cmd += '.elm --output=' + example + '.html'

    cp.exec cmd, (error, stdout) ->

      if error
        console.log "Elm error :^( "
        console.log error
      else
        console.log 'Elm says .. '
        console.log (stdout.slice 0, stdout.length - 1)


gulp.task 'watch', ->
  autowatch gulp, elm: './*.elm'

gulp.task 'server', -> require './server'

gulp.task 'default', 
  [ 'elm', 'watch', 'server' ]





 