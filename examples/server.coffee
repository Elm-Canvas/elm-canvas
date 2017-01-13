fs          = require 'fs'
express     = require 'express'
app         = express()
http        = require 'http'
{join}      = require 'path'
bodyParser  = require 'body-parser'

app.use bodyParser.json()

PORT = Number process.env.PORT or 2993

app.use express.static __dirname

httpServer = http.createServer app
httpServer.listen PORT, ->
  console.log 'SERVER RUNNING ON ' + PORT