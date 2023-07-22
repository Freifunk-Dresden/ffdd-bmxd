#!/bin/bash

usage()
{
	echo "$(basename $0) [-d] [-p port ] [-v version ] upload"
	echo ""
	echo "-d	dryrun"
	echo "-p	ssh port (default: $PORT)"
	echo "-v	version (e.g: 1.2-7e90273293649e046a67dbada9de629d)"
	echo ""
	echo "Example: $(basename $0) -p 2202 -v 1.2-7e90273293649e046a67dbada9de629d upload"
	echo ""
}

TARGET="root@download.freifunk-dresden.de:/var/www/files/server/packages"
PORT="2202"
VERSION=
CMD=

while getopts "hp:v:d" ARG
do
	case "$ARG" in
		h)	usage; exit 1 ;;
		p)	PORT="${OPTARG}" ;;
		v)	VERSION="${OPTARG}" ;;
		d)	DRYRUN=echo ;;
		\?)	usage; exit 1 ;;
	esac
done
shift $(( OPTIND - 1 ))
CMD="$1"

#echo "port:    $PORT"
#echo "version: $VERSION"
#echo "cmd:     $CMD"

if [ "$CMD" != "upload" -o -z "$VERSION" ]; then
	echo "Error: missing command/parameters"
	usage
	exit 1
fi

if [ -z "${DRYRUN}" ]; then
	echo "uploading packages/bmxd-${VERSION}-*"
else
	echo "dryrun..."
fi

${DRYRUN} scp -P ${PORT} packages/bmxd-${VERSION}-debian-buster-amd64.deb ${TARGET}/debian10/
${DRYRUN} scp -P ${PORT} packages/bmxd-${VERSION}-debian-bullseye-amd64.deb  ${TARGET}/debian11/

# ubuntu 22 nutzt die gleichen pakete wie ubuntu20, da es bei ubuntu22 compile fehler gibt
${DRYRUN} scp -P ${PORT} packages/bmxd-${VERSION}-ubuntu-focal-amd64.deb   ${TARGET}/ubuntu20/
${DRYRUN} scp -P ${PORT} packages/bmxd-${VERSION}-ubuntu-focal-amd64.deb   ${TARGET}/ubuntu22/bmxd-${VERSION}-ubuntu-jammy-amd64.deb

