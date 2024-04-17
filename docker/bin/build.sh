#!/bin/bash -xe
export php_ver=${PHP_VER:-8-fpm-alpine}
export jamroom_ver=${JAMROOM_VER:-7.0.1}

podman build --rm -t stremki/genosis:${PHP_VER} --build-arg JAMROOM_VER=${jamroom_ver} --build-arg PHP_VER=${php_ver} -f Dockerfile .
docker image prune -f
