#!/bin/bash


docker run -it --rm -w /mnt/ -v $PWD:/mnt/ ubuntu:18.04 bash -c "./install-deps.sh; ./build-bmxd-deb.sh"
