FROM node:24-alpine

RUN apk add --no-cache \
    autoconf \
    automake \
    libtool \
    nasm \
    build-base \
    pkgconfig

CMD "npm install -g npm@latest"

EXPOSE 5173
