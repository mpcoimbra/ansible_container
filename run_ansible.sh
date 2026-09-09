#!/bin/bash

if [ -f /usr/bin/podman ]; then
    podman run --rm -it \
    -v $(pwd):/ansible:Z \
    -v ~/.ssh:/root/.ssh:ro,Z \
    -v ~/:/root/:Z \
    -v /tmp:/tmp:Z \
       custom-ansible:2.21.3-suse  "$@"

elif [ -f /usr/bin/docker ]; then
    docker run --rm -it \
    -v $(pwd):/ansible:Z \
    -v ~/.ssh:/root/.ssh:ro,Z \
    -v ~/:/root/:Z \
    -v /tmp:/tmp:Z \
       custom-ansible:2.21.3-suse  "$@"

else
    echo "Neither podman nor docker found. Exiting."
    exit 1
fi

# This script is meant to be run from the directory where the Ansible playbook is located.
# It will run the playbook using the container.

# The container name is custom-ansible:2.21.3-suse
# The image is custom-ansible:2.21.3
