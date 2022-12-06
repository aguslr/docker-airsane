FROM docker.io/debian:stable-slim

ARG AIRSANE_REPO=https://github.com/SimulPiscator/AirSane
ARG AIRSANE_TAG=v0.3.5

ARG BUILD_DATE
ARG BUILD_VERSION=unspecified
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=${BUILD_DATE}
LABEL org.label-schema.version=${BUILD_VERSION}

RUN \
  apt-get update && \
  env DEBIAN_FRONTEND=noninteractive \
  apt-get install -y --no-install-recommends \
  wget ca-certificates sane-utils build-essential cmake g++ \
  libsane-dev libjpeg-dev libpng-dev libavahi-client-dev libusb-1.*-dev \
  -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /var/lib/apt/lists/*

WORKDIR /opt/AirSane
RUN \
  wget ${AIRSANE_REPO}/archive/refs/tags/${AIRSANE_TAG}.tar.gz -O - \
  | tar -xzv --strip-components=1 && \
  mkdir ./build && cd ./build && cmake .. && make && make install

COPY entrypoint.sh /entrypoint.sh

EXPOSE 8090/tcp

VOLUME /dev/bus/usb /run/dbus

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--access-log=-", "--disclose-version=false", "--debug=true"]
