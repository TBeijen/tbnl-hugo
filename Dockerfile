# See: https://docs.docker.com/reference/dockerfile/#automatic-platform-args-in-the-global-scope
FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:alpine AS build

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG HUGO_VERSION="0.63.1"
ARG HUGO_ARCH="64bit"
ARG GIT_REVISION="sha-notset"

ENV GIT_REVISION_ENV=${GIT_REVISION}

RUN BUILD_ARCH_UC=$(echo $BUILDPLATFORM | awk -F'/' '{print $2}' | tr '[:lower:]' '[:upper:]') && \
    if [ $BUILD_ARCH_UC == "ARM64" ]; then HUGO_ARCH="ARM64"; fi && \
    wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-${HUGO_ARCH}.tar.gz -O /tmp/hugo.tar.gz && \
    cd /tmp && \
    tar xzvf hugo.tar.gz && \
    mv ./hugo /usr/local/bin/hugo

RUN mkdir -p /opt/tbnl/source && \
    mkdir -p /opt/tbnl/build

WORKDIR /opt/tbnl

COPY . ./source

RUN sed -i -e "s/gitRevision.*=.*/gitRevision = \"${GIT_REVISION_ENV}\"/" ./source/config/generic/params.toml

RUN hugo -e generic --source=${PWD}/source --destination=${PWD}/build/generic

# Final image
FROM --platform=${TARGETPLATFORM:-linux/amd64} nginx:1.25.4-alpine

COPY --from=build /opt/tbnl/build/generic /usr/share/nginx/html
