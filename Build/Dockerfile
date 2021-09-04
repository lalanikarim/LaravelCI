FROM composer:2.1.6
RUN apk add git openssh rsync npm
RUN addgroup -g 5000 nonroot
RUN adduser --home /home/nonroot --uid 5000 -G nonroot \
    --shell /bin/bash -k /dev/null -H -D nonroot
RUN mkdir -p /home/nonroot /app
RUN chown nonroot:nonroot /home/nonroot /app
USER nonroot
WORKDIR /home/nonroot
COPY build.sh .
VOLUME /app
ENTRYPOINT . ./build.sh
