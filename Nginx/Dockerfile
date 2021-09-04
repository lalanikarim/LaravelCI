FROM ubuntu:20.04 as nvm
RUN apt update
RUN apt install curl -y
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN bash -c ". $NVM_DIR/nvm.sh; nvm install 14"
COPY . /app
WORKDIR /app
RUN bash -c ". $NVM_DIR/nvm.sh; npm install"
RUN bash -c ". $NVM_DIR/nvm.sh; npm run prod"

FROM nginx:1.21.1
WORKDIR /var/www/html
COPY . /var/www/html
COPY --from=nvm /app/public/js /var/www/html/public/
COPY --from=nvm /app/public/css /var/www/html/public/
COPY --from=nvm /app/public/fonts /var/www/html/public/
RUN [ -e .env ] && rm .env > /dev/null &2>1
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
