#!/usr/bin/env bash

# pulls the new configuration from Github and runs nixos-rebuild switch
# must be run as root

pushd /etc/nixos/
git pull
popd
nixos-rebuild switch
