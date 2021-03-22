#!/bin/sh
set -e

p_path=/usr/local/lib/php/extensions/precompiled
z_path=/usr/local/lib/php/extensions/no-debug-non-zts-20200930
apk update

if [ ! -f $p_path/mysqli.so ]; then
  docker-php-source extract
  docker-php-ext-configure mysqli
  docker-php-ext-install -j2 mysqli
  docker-php-source delete
fi
test -f $z_path/mysqli.so || cp $p_path/mysqli.so $z_path/mysqli.so

if [ ! -f $p_path/gd.so ]; then
  apk add zlib-dev
  apk add libpng-dev
  apk add libjpeg-turbo-dev
  apk add freetype-dev
  docker-php-source extract
  docker-php-ext-configure gd --with-freetype --with-jpeg
  docker-php-ext-install -j2 gd
  docker-php-source delete
  apk del freetype-dev
  apk del libjpeg-turbo-dev
  apk del libpng-dev
  apk del zlib-dev
fi
test -f $z_path/gd.so || cp $p_path/gd.so $z_path/gd.so

apk add zlib
apk add libpng
apk add libjpeg-turbo
apk add freetype

chown www-data:www-data /var/www/data -R || true

/usr/local/sbin/php-fpm -n -y /usr/local/etc/php-fpm.conf -d log_errors=on -d error_log=/var/log/php/genosis.error.log -d extension=mysqli.so -d extension=gd.so -F -O
