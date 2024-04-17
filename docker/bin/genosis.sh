#!/bin/sh
echo "PHP Info"
/usr/local/sbin/php-fpm -i
echo "PHP FPM compiled modules"
/usr/local/sbin/php-fpm -m
echo "Starting the app"
/usr/local/sbin/php-fpm -y /etc/genosis-fpm.conf -d extension=gd.so -d log_errors=on -d error_log=/var/log/php/genosis.error.log -F -O
