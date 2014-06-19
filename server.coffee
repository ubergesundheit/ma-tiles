# Tile server using the node web framework Express (http://expressjs.com).
express = require "express"
tilelive = require "tilelive"
Vector = require "tilelive-vector"
TileJSON = require "tilejson"
fs = require "fs"
mkdirp = require "mkdirp"

app = express()

Vector.registerProtocols tilelive

tilelive.protocols["mapbox:"] = Source = (uri, callback) ->
  new TileJSON("http://a.tiles.mapbox.com/v3#{uri.pathname}.json", callback)
  return

filename = __dirname + "/osm-bright.tm2z"
Vector.mapnik.register_fonts __dirname + "/fonts/"


tilelive.load "tm2z://" + filename, (err, source) ->
  console.log "Listening on port: " + 8888
  app.listen 8888
  throw err  if err
  app.get "/tiles/:z/:x/:y.*", (req, res) ->
    z = req.param("z")
    x = req.param("x")
    y = req.param("y")
    filepath = "tiles/#{z}/#{x}/"
    source.getTile z, x, y, (err, tile, headers) ->
      # `err` is an error object when generation failed, otherwise null.
      # `tile` contains the compressed image file as a Buffer
      # `headers` is a hash with HTTP headers for the image.
      unless err
        mkdirp filepath, (err) ->
          unless err
            fs.open "#{filepath}#{y}.png", "w", (err, file) ->
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

        res.set('Content-Type', 'image/png')
        res.send tile

      else
        res.send "Tile rendering error: " + err + "\n"

      return

    return

  return

console.log 'starting server, please stand by!'
