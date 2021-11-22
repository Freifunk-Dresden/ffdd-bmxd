#!/bin/bash

echo "unsetting env-variable \$DOCKER_HOST"
unset DOCKER_HOST


for linux in ubuntu:18.04 ubuntu:20.04 debian:9 debian:10
do
	docker run -it --rm -w /mnt/ -v $PWD:/mnt/ ${linux} bash -c "./tools/install-deps.sh; ./tools/build-bmxd-deb.sh $(id -u) $(id -g)"
done
