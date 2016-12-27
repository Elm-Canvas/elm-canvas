gulp       = require 'gulp'
autowatch  = require 'gulp-autowatch'
source     = require 'vinyl-source-stream'
buffer     = require 'vinyl-buffer'
cp         = require 'child_process'
stylus     = require 'gulp-stylus'
coffeeify  = require 'coffeeify'
browserify = require 'browserify'

devSrc = (path) ->
  './src/' + path

paths =
  public:   './public'
  elm:      devSrc 'elm/**/*.elm'
  css:      devSrc 'css/*.styl'
  coffee:   devSrc 'js/*.coffee'

gulp.task 'coffee', ->
  bCache = {}
  b = browserify (devSrc 'js/app.coffee'),
    debug: true
    interestGlobals: false
    cache: bCache
    extensions: ['.coffee']
  b.transform coffeeify
  b.bundle()
  .pipe source 'app.js'
  .pipe buffer()
  .pipe gulp.dest paths.public

gulp.task 'stylus', ->
  gulp.src paths.css
  .pipe stylus()
  .pipe gulp.dest paths.public

gulp.task 'elm', ->  
  cmd  = 'elm-make '
  cmd += devSrc 'elm/main.elm'
  cmd += ' --output ./public/elm.js'

  cp.exec cmd, (error, stdout) ->
    if error
      console.log "Elm error :^( "
      console.log error
    else
      console.log 'Elm says .. '
      console.log (stdout.slice 0, stdout.length - 1)

gulp.task 'watch', ->
  autowatch gulp,
    server:   './public/*.html'
    stylus:   paths.css
    coffee:   paths.coffee
    elm:      [ '../src/**/*', paths.elm, devSrc 'elm/*/**.js']

gulp.task 'server', -> require './server'

gulp.task 'default', 
  [ 'elm', 'coffee', 'stylus', 'watch', 'server' ]





 