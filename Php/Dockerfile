FROM composer:2.1.3 as build
RUN apk add npm
WORKDIR /app
COPY . /app
RUN [ -e composer.json ] && composer install > /dev/null 2>&1
RUN [ -e .env ] && rm .env > /dev/null 2>&1

FROM php:7.4.21-fpm
EXPOSE 9000
COPY --from=build /app /var/www/html
WORKDIR /var/www/html/public
RUN chown -R www-data:www-data /var/www/html
RUN docker-php-ext-install pdo pdo_mysql
