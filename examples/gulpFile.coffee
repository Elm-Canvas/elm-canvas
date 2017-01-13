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
    '7-crop',
    '8-request-animation-frame'
  ]

gulp.task 'elm', ->  

  _.forEach elmExamples, (example) ->
    cmd  = 'elm-make ./' + example 
    cmd += '.elm --output=' + example + '.html'

    console.log (cp.execSync cmd, (encoding: 'utf-8'))


gulp.task 'watch', ->
  autowatch gulp, elm: './*.elm'

gulp.task 'server', -> require './server'

gulp.task 'default', 
  [ 'elm', 'watch', 'server' ]





 