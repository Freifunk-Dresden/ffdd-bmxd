#!/bin/bash

echo "unsetting env-variable \$DOCKER_HOST"
unset DOCKER_HOST

# change dir to script directory
cd $(dirname $0)
curdir="$(pwd)"

# --- ubuntu 22.04 hat noch fehler beim bauen
# for linux in ubuntu:20.04 ubuntu:22.04 debian:10 debian:11

for linux in ubuntu:20.04 debian:10 debian:11
do
  name="${linux/:/_}"

	# get mounted directory (just to display or check if container already exists
	# and matches the current directory)
	containerMountDir="$(docker inspect ${name} | jq -r '.[0].HostConfig.Binds[0]')"
	containerMountDir="${containerMountDir/:*/}"

	# check path, if container does not exist -> create container
	if [ "$curdir" != "$containerMountDir" ]; then
		# check path, if container exist, but mounted dir is different -> re-create
		if [ "$containerMountDir" != "null" ]; then
			echo "delete old container - mounted directory does not match"
			docker container rm ${name}
		fi

		echo "create new container"
	docker create -it --name ${name} -w /mnt/ -v $PWD:/mnt/ ${linux} bash -c "./tools/install-deps.sh; ./tools/build-bmxd-deb.sh $(id -u) $(id -g)"
	fi

	echo "start container and generate debs"
	docker start -i ${name}

done
