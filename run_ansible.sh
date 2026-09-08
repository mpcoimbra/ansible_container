#!/bin/bash
podman run --rm -it \
-v $(pwd):/ansible:Z \
-v ~/.ssh:/root/.ssh:ro,Z \
-v ~/.ansible:/root/.ansible:Z \
custom-ansible:2.21.3-suse  "$@"
