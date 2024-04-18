#!/bin/bash -xe
export alpine_ver=${ALPINE_VER:-3.19}
export php_ver=${PHP_VER:-8-fpm-alpine${alpine_ver}}
export nginx_ver=${NGINX_VER:-mainline-alpine${alpine_ver}}
export jamroom_ver=${JAMROOM_VER:-7.0.1}

DOCKER_BUILDKIT=0 podman build --build-arg JAMROOM_VER=${jamroom_ver} --build-arg PHP_VER=${php_ver} -f Dockerfile.php -t localhost/stremki/genosis_app:${php_ver} .
DOCKER_BUILDKIT=1 podman build --build-arg NGINX_VER=${nginx_ver} --build-arg JAMROOM_VER=${jamroom_ver} -f Dockerfile.nginx -t localhost/stremki/genosis_web:${nginx_ver} .
docker image prune -f
