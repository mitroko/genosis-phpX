**purpose**

This repo is mainly created to share sources for jamroom team.
It is mentioned in https://www.jamroom.net/the-jamroom-network/forum/genosis/64633/microservices-on-php8 thread.

Here you can find **docker-compose.yml** for building microservices stack to run jamroom/genosis on docker.

**Structure:**
./patches/ - patches to be applied to run jamroom/genosis on php6+
./docker/app - unpacked jamroom code without trailing dir
./docker/config - read-only folder for config.php file which controls jamroom infrastructure opts.
./docker/docker-compose.yml - compose template
./docker/fpm - php-fpm infrastructure configs and cache
./docker/innodb_tweaks.conf - conf.d file for mariadb to tune jamroom mysql connections
./docker/logs - forlder to store nginx and php output
./docker/nginx.conf - nginx core config for php-fpm
