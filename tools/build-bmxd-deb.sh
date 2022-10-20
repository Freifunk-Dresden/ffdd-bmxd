#!/usr/bin/env bash

REPO="https://github.com/freifunk-dresden/ffdd-bmxd.git"
#BRANCH="latest_server"
BRANCH="master"

# args: user and group ids are used to correct access rights of generated
#       deb-packages
userid=$1
groupid=$2

if [ -z "$groupid" ]; then
	echo "missing params (userid, groupid)"
	exit 1
fi


CURDIR="$PWD"
PACKAGE_DIR="${CURDIR}/packages"
BUILD_DIR="/tmp/build_bmxd"

# prepare directories
test -d ${PACKAGE_DIR} && rm -rf ${BUILD_DIR}
mkdir -p ${PACKAGE_DIR}
mkdir -p ${BUILD_DIR}

# clone bmxd
cd ${BUILD_DIR}
git clone ${REPO} bmxd

# build bmxd
cd ${BUILD_DIR}/bmxd/sources || exit 1
git checkout ${BRANCH}
git branch -av

make clean
make

# build deb package
chmod 755 DEBIAN
chmod 555 DEBIAN/*

BMXD_ARCH='amd64'
BMXD_VERSION="$(awk '/SOURCE_VERSION/ {print $3}' batman.h | head -1 | sed -e 's/^"//' -e 's/"$//' -e 's/-freifunk-dresden//')"
BMXD_SOURCE_MD5="$(md5sum *.[ch] Makefile | md5sum | cut -d' ' -f1)"
BMXD_REVISION="${BMXD_SOURCE_MD5}"

# package directories and files
mkdir -p OUT/usr/sbin/
cp bmxd OUT/usr/sbin/
cp -RPfv DEBIAN OUT/

# update control infos and md5sum of all files
cd OUT
sed -i "s/ARCH/$BMXD_ARCH/g" DEBIAN/control
sed -i "s/VERSION/$BMXD_VERSION/g" DEBIAN/control
sed -i "s/REVISION/$BMXD_REVISION/g" DEBIAN/control
md5sum "$(find . -type f | grep -v '^[.]/DEBIAN/')" > DEBIAN/md5sums

eval $(cat /etc/os-release)
deb_name="bmxd-${BMXD_VERSION}-${BMXD_REVISION}-${ID}-${VERSION_CODENAME}-${BMXD_ARCH}.deb"
echo dpkg-deb --build ./ ${PACKAGE_DIR}/$deb_name
dpkg-deb --build ./ ${PACKAGE_DIR}/$deb_name

chown -R ${userid}:${groupid} ${PACKAGE_DIR}

exit 0
