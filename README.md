# Mopidy + Iris Alpine Docker Image

![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/log1x/mopidy-iris?style=flat-square)
![Docker Pulls](https://img.shields.io/docker/pulls/log1x/mopidy-iris?style=flat-square)
![Docker Stars](https://img.shields.io/docker/stars/log1x/mopidy-iris?style=flat-square)

[Iris](https://github.com/jaedb/Iris) (formerly known as Spotmop) is an extension for the Mopidy music server. With support for Spotify, LastFM, Snapcast, Icecast and many other extensions, Iris is the software that brings all your music into one user-friendly and unified interface.

## Usage

```bash
$ docker run -d \
  -p 6600:6600 \
  -p 6680:6680 \
  -p 5555:5555/udp \
  --name=<container name> \
  -v <path for data files>:/data \
  -v <path for music files>:/music \
  -v <path for playlist files>:/playlists \
  log1x/mopidy-iris
```

- **Iris (Web UI):** `http://<host>:6680`

## Bug Reports

If you discover a bug in docker-mopidy-iris, please [open an issue](https://github.com/log1x/docker-mopidy-iris/issues).

## Contributing

Contributing whether it be through PRs, reporting an issue, or suggesting an idea is encouraged and appreciated.

## License

docker-mopidy-iris is provided under the [MIT License](https://github.com/log1x/docker-mopidy-iris/blob/master/LICENSE.md).
