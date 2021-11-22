#!/bin/bash


docker run -it  -w /mnt/ -v $PWD:/mnt/ ubuntu:18.04 bash -c "./tools/install_deps.sh; ./tools/build_bmxd.sh"
