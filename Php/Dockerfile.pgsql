FROM docker.io/php:8.0.11-fpm-alpine3.14
EXPOSE 9000
WORKDIR /var/www/html/public
RUN apk add postgresql-client postgresql-dev
RUN docker-php-ext-install pdo pdo_pgsql
RUN apk add linux-pam bash shadow
RUN apk add librdkafka-dev g++ gcc make autoconf
RUN pecl install rdkafka
RUN echo "extension=rdkafka.so" > /usr/local/etc/php/conf.d/kafka.ini
RUN docker-php-ext-install exif pcntl
RUN mkhomedir_helper www-data
RUN usermod -d /home/www-data www-data
RUN chown -R www-data:www-data /home/www-data
RUN chmod -R +w /home/www-data
USER www-data
ENV HOME /home/www-data
