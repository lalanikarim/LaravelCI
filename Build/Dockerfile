FROM docker.io/composer:2.1.6
RUN apk add git rsync npm
RUN docker-php-ext-install exif gd pcntl xml
RUN deluser xfs
RUN addgroup -g 33 nonroot
RUN adduser --home /home/nonroot --uid 33 -G nonroot \
    --shell /bin/bash -k /dev/null -H -D nonroot
RUN mkdir -p /home/nonroot 
RUN chown -R nonroot:nonroot /home/nonroot 
USER nonroot
WORKDIR /home/nonroot
COPY build.sh .
ENTRYPOINT . ./build.sh
