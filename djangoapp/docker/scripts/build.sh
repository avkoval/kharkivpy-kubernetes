#!/usr/bin/env bash

# This file is needed separately from Dockerfile as now we can use it from
# both Dockerfile and Dockerfile.prod

PACKAGES=(
  bash
  ca-certificates
  gettext
  locales
  locales-all
  mime-support
  nano
  net-tools
  netcat
  postgresql-client
  psmisc
)

DEV_PACKAGES=(
  build-essential
  curl
  gcc
  git
  libjpeg-dev
  libpango1.0-dev
  libpq-dev
  libxml2-dev
  make
)

if [ "$1" == "install" ]
then
  apt-get update
  apt-get install -y "${PACKAGES[@]}"
  apt-get install -y "${DEV_PACKAGES[@]}"
else
  apt-get remove -y "${DEV_PACKAGES[@]}"
fi
