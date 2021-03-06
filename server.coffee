# Tile server using the node web framework Express (http://expressjs.com).
express = require "express"
tilelive = require "tilelive"
Vector = require "tilelive-vector"
TileJSON = require "tilejson"
tmsource = require 'tilelive-tmsource'
fs = require "fs"
mkdirp = require "mkdirp"

app = express()

access_token = process.env.MAPBOX_ACCESS_TOKEN
style_name = process.env.STYLE_NAME || 'osm-bright'

Vector.registerProtocols tilelive

tilelive.protocols["mapbox:"] = (uri, callback) ->
  new TileJSON("http://api.tiles.mapbox.com/v4#{uri.pathname}.json?access_token=#{access_token}", callback)
  return

tilelive.protocols["http:"] = TileJSON
tilelive.protocols["https:"] = TileJSON

filename = __dirname + "/#{style_name}.tm2z"
Vector.mapnik.register_fonts __dirname + "/fonts/"


tilelive.load "tm2z://" + filename, (err, source) ->
  console.log "Listening on port: " + 8888
  app.listen 8888
  throw err if err

  respondWithTile = (req, res) ->

    z = req.params.z
    x = req.params.x
    y = req.params.y
    scale = parseInt(req.params.scale[1..-2]) if req.params.scale?

    filepath = "tiles/#{z}/#{x}/"
    renderCallback = (err, tile, headers) ->
      # `err` is an error object when generation failed, otherwise null.
      # `tile` contains the compressed image file as a Buffer
      # `headers` is a hash with HTTP headers for the image.
      unless err
        content_type = headers['Content-Type']
        file_extension = content_type.split('/')[1]
        mkdirp filepath, (err) ->
          unless err
            if scale? then scalestr = "@#{scale}x" else scalestr = ""
            fs.open "#{filepath}#{y}#{scalestr}.#{file_extension}", "w", (err, file) ->
              unless err
                fs.write file, tile, 0, tile.length, null, (err, written, buffer) ->
                  fs.close file
                  return
              else
                console.log 'error writing file', err

              return

          else
            console.log 'error creating directories', err

          return
        res.set('Content-Type', content_type)
        res.send tile

      else
        res.send "Tile rendering error: " + err + "\n"

      return
    renderCallback.scale = scale
    source.getTile z, x, y, renderCallback

    return

  app.get "/:z(\\d+)/:x(\\d+)/:y(\\d+):scale(@\\d+x).*", respondWithTile
  app.get "/:z(\\d+)/:x(\\d+)/:y(\\d+).*", respondWithTile
  return

console.log 'starting server, please stand by!'
