ARG PHP_VER
ENV PHP_VER=${PHP_VER:-8-fpm-alpine}

FROM docker.io/library/php:$PHP_VER as build
MAINTAINER "Dzmitry Stremkouski <mitroko@gmail.com>"

ARG JAMROOM_VER
ENV JAMROOM_VER=${JAMROOM_VER:-7.0.0}
WORKDIR /tmp
RUN mkdir -p /tmp/php
COPY src/genosis-open-source-$JAMROOM_VER.zip /tmp/php
RUN cd /tmp/php && unzip genosis-open-source-$JAMROOM_VER.zip
# RUN find /tmp/php/genosis-open-source -type f \( -iname *.LICENSE -o -iname *.png -o -iname *.gif -o -iname *.jpg -o -iname *.css -o -iname *.html -o -iname *.txt -o -iname *.js -o -iname *.svg -o -iname *.ico -o -iname *.json -o -name LICENSE -o -iname *.md -o -iname *.markdown -o -name .htaccess -o -name .DS_Store \) -delete
 
RUN apk --no-cache update && apk --no-cache add zlib-dev libpng-dev libjpeg-turbo-dev freetype-dev zlib libpng libjpeg-turbo freetype

RUN docker-php-source extract
RUN docker-php-ext-configure mysqli
RUN docker-php-ext-install -j2 mysqli
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j2 gd
RUN docker-php-source delete

RUN apk --no-cache del freetype-dev libjpeg-turbo-dev libpng-dev zlib-dev
RUN rm -f /usr/local/etc/php-fpm.conf /usr/local/etc/php-fpm.d/zz-docker.conf /usr/local/etc/php-fpm.d/www.conf

FROM docker.io/library/php:$PHP_VER as localhost/stremki/genosis_app:$PHP_VER
MAINTAINER "Dzmitry Stremkouski <mitroko@gmail.com>"
ENV JAMROOM_VER=${JAMROOM_VER}
ENV PHPFPM_VER=${PHP_VER}

COPY --from=build /usr/local /usr/local
COPY --from=build /tmp/php/genosis-open-source /var/www
COPY fpm/genosis-fpm.conf /etc
COPY bin/genosis.sh bin/entrypoint.sh /bin
RUN apk --no-cache update && apk --no-cache add zlib libpng libjpeg-turbo freetype
RUN echo '<?php phpinfo(); ?>' > /var/www/phpinfo.php
 
RUN mkdir -p /var/www/data /var/www/modules /var/www/skins && chmod 0755 /var/www/data /var/www/modules /var/www/skins && chown -R www-data:www-data /var/www/data /var/www/modules /var/www/skins

ENTRYPOINT ["/bin/entrypoint.sh"]
