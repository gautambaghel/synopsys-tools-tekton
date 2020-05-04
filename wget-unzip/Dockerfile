FROM alpine:3.11

RUN apk add --update \
    wget zip unzip \
    && rm -rf /var/cache/apk/*

ENTRYPOINT ["/bin/sh"]