FROM php:7.4.21-fpm
EXPOSE 9000
WORKDIR /var/www/html/public
RUN docker-php-ext-install pdo pdo_mysql
USER www-data
