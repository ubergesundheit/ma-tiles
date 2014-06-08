# Serves tilemill 2 tm2z files

Using
- [tilelive](https://github.com/mapbox/tilelive.js)
- [tilelive-vector](https://github.com/mapbox/tilelive-vector)
- [express](https://github.com/visionmedia/express)
- [nginx](http://nginx.org/)


## Usage

- install [docker](https://www.docker.io)
- build the image `sudo docker build -t ma-tiles .`
- run it `sudo docker run -p 80:80 -d ma-tiles`
- fetch tiles `http://your-host/tiles/z/x/y.png`
