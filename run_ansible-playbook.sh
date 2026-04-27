#!/bin/bash
podman run --rm -it -v $(pwd):/ansible:Z -v ~/.ssh:/root/.ssh:ro,Z  custom-ansible ansible-playbook "$@"
