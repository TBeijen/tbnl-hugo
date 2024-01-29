FROM --platform=$BUILDPLATFORM golang:alpine AS build

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG HUGO_VERSION=0.63.1

RUN ARCH_UC=$(echo $BUILDPLATFORM | awk -F'/' '{print $2}' | tr '[:lower:]' '[:upper:]') && \
    if [ $ARCH_UC == "AMD64" ]; then ARCH_UC="64bit"; fi && \
    echo $ARCH_UC && \
    echo wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-$ARCH_UC.tar.gz -O /tmp/hugo.tar.gz && \
    wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-$ARCH_UC.tar.gz -O /tmp/hugo.tar.gz && \
    cd /tmp && \
    tar xzvf hugo.tar.gz && \
    mv ./hugo /usr/local/bin/hugo

RUN mkdir -p /opt/tbnl/source && \
    mkdir -p /opt/tbnl/build

WORKDIR /opt/tbnl

COPY . ./source

RUN hugo -e generic --source=${PWD}/source --destination=${PWD}/build/generic

# Final image
FROM nginx:stable-alpine3.17

COPY --from=build /opt/tbnl/build/generic /usr/share/nginx/html
