#!/usr/bin/env bash

apt update -y

# installing tzdata requires user input normally.
# to avoid blocking tzdata must be installed differently
DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends tzdata

apt install -y git gettext curl wget time rsync jq \
	nodejs build-essential devscripts debhelper libssl-dev libncurses5-dev unzip gawk zlib1g-dev subversion gcc-multilib flex \
	libjson-c-dev clang lua5.1 liblua5.1-dev cmake

exit 0
