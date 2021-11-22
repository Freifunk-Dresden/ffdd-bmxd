#!/usr/bin/env bash


CURDIR="$PWD"

BUILD_DIR="/tmp/build_bmxd"

mkdir -p $BUILD_DIR ; cd BUILD_DIR

git clone https://github.com/ddmesh/ffdd-bmxd.git bmxd
cd bmxd || exit 1
#git checkout latest_server
git checkout master

cd sources

chmod 755 DEBIAN
chmod 555 DEBIAN/*

make clean
make

ARCH='amd64'
VERSION="$(awk '/SOURCE_VERSION/ {print $3}' batman.h | head -1 | sed -e 's/^"//' -e 's/"$//' -e 's/-freifunk-dresden//')"
SOURCE_MD5="$(md5sum *.[ch] linux/*.[cp] posix/*.[cp] Makefile | md5sum | cut -d' ' -f1)"
REVISION="${SOURCE_MD5}"

mkdir -p OUT/usr/sbin/
cp bmxd OUT/usr/sbin/
cp -RPfv DEBIAN OUT/

cd OUT
sed -i "s/ARCH/$ARCH/g" DEBIAN/control
sed -i "s/VERSION/$VERSION/g" DEBIAN/control
sed -i "s/REVISION/$REVISION/g" DEBIAN/control
md5sum "$(find . -type f | grep -v '^[.]/DEBIAN/')" > DEBIAN/md5sums

eval $(cat /etc/os-release)
deb_name="bmxd-${VERSION}-${REVISION}_${VERSION_CODENAME}_${ARCH}.deb"
dpkg-deb --build ./ ../../$deb_name

# copy back package

RESULT_DIR="${CURDIR}/packages/${ID}-${VERSION_ID}-${VERSION_CODENAME}"
mkdir -p ${RESULT_DIR}
cp ../../$deb_name ${RESULT_DIR}/

exit 0
