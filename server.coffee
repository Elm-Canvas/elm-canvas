fs          = require 'fs'
express     = require 'express'
app         = express()
http        = require 'http'
{join}      = require 'path'
bodyParser  = require 'body-parser'

app.use bodyParser.json()

PORT = Number process.env.PORT or 2996

app.use express.static join __dirname, '/public'

app.get '/', (req, res, next) ->
  indexPage = join __dirname, 'public/index.html'
  res.status 200
    .sendFile indexPage

httpServer = http.createServer app
httpServer.listen PORT, ->
  console.log 'SERVER RUNNING ON ' + PORT