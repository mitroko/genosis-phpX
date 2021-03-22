#!/bin/sh
set -e

p_path=/usr/local/lib/php/extensions/precompiled
z_path=/usr/local/lib/php/extensions/no-debug-non-zts-20131226
apt update

if [ ! -f $p_path/mysqli.so ]; then
  docker-php-source extract
  docker-php-ext-configure mysqli
  docker-php-ext-install -j2 mysqli
  docker-php-source delete
fi
test -f $z_path/mysqli.so || cp $p_path/mysqli.so $z_path/mysqli.so
test -f $p_path/mysqli.so || cp $z_path/mysqli.so $p_path/mysqli.so

if [ ! -f $p_path/gd.so ]; then
  apt -y install zlib1g-dev libpng-dev libjpeg-dev libfreetype6-dev libvpx-dev libxpm-dev
  docker-php-source extract
  docker-php-ext-configure gd \
    --with-vpx-dir=/usr/include \
    --with-jpeg-dir=/usr/include \
    --with-xpm-dir=/usr/include/X11 \
    --with-freetype-dir=/usr/include \
    --with-gd
  docker-php-ext-install -j2 gd
  docker-php-source delete
  apt -y purge zlib1g-dev libpng-dev libjpeg-dev libfreetype6-dev
fi
test -f $z_path/gd.so || cp $p_path/gd.so $z_path/gd.so
test -f $p_path/gd.so || cp $z_path/gd.so $p_path/gd.so

apt -y install \
  zlib1g \
  libpng16-16 \
  libjpeg62-turbo \
  libfreetype6 \
  libvpx4 \
  libxpm4 \
  procps \
  lsb-release \
  wget \
  mariadb-client

chown www-data:www-data /var/www/data -R || true
chown www-data:www-data /var/www/modules -R || true
chown www-data:www-data /var/www/skins -R || true

/usr/local/sbin/php-fpm -n -y /usr/local/etc/php-fpm.conf \
  -d log_errors=on \
  -d error_log=/var/log/php/genosis.error.log \
  -d extension=mysqli.so \
  -d extension=gd.so \
  -d zend_extension=opcache.so \
  -F -O
