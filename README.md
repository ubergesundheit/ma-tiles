# Serves tilemill 2 tm2z files

Using
- [tilelive](https://github.com/mapbox/tilelive.js)
- [tilelive-vector](https://github.com/mapbox/tilelive-vector)
- [express](https://github.com/visionmedia/express)
- [nginx](http://nginx.org/)


## Usage

- install [docker](https://www.docker.io)
- install [fig](http://www.fig.sh)
- obtain a [Mapbox access token](https://www.mapbox.com/help/create-api-access-token/) and put it into your `fig.yml`
- configure the `fig.yml`. the `STYLE_NAME` variable (without .tm2z) should exist in the project root.
- build the image `sudo fig build`
- run it `sudo fig up` or `sudo fig up -d` if you want to start as a daemon
- fetch tiles `http://your-host:9999/{z}/{x}/{y}.png`
