# Serves tilemill 2 tm2z files

Using
- [tilelive](https://github.com/mapbox/tilelive.js)
- [tilelive-vector](https://github.com/mapbox/tilelive-vector)
- [express](https://github.com/visionmedia/express)
- [nginx](http://nginx.org/)


## nginx config
your config should at least contain the following:

```
  root <THE_ABSOLUTE_PATH_TO_THIS_DIRECTORY>/tiles/;

  location ~* ^/tiles/(?<tile_path>.*)$ {
    try_files $tile_path @node;
  }

  location @node {
    proxy_pass http://localhost:8888;
  }
```
