# ansible_container
This repository contains files for the containerized version of Ansible

## Building the Container

You can build the container image using either Podman or Docker. In the examples below, the resulting image will be tagged as `custom-ansible`.

### Customizing the Ansible Version

By default, the container builds with a specific Ansible version defined in the `ansible.Containerfile` (e.g., `2.16.16`). You can override this during the build process using the `ANSIBLE_VERSION` build argument.

**Podman:**
```bash
podman build --build-arg ANSIBLE_VERSION=2.15.5 -t custom-ansible -f ansible.Containerfile .
```

**Docker:**
```bash
docker build --build-arg ANSIBLE_VERSION=2.15.5 -t custom-ansible -f ansible.Containerfile .
```

### Using Podman
```bash
podman build -t custom-ansible -f ansible.Containerfile .
```

### Using Docker
```bash
docker build -t custom-ansible -f ansible.Containerfile .
```

## Executing the Container

When executing the Ansible container, it is typical to mount your local projects (playbooks, inventory, etc.) and your SSH keys so that Ansible can access the hosts. The working directory inside the container is set to `/ansible`.

### Using Podman

**Basic execution (shows Ansible help):**
```bash
podman run --rm -it custom-ansible
```

**Running an Ansible Playbook:**
Map your current directory and SSH keys to the container payload. The `:Z` flag ensures SELinux contexts are correctly applied.
```bash
podman run --rm -it \
  -v $(pwd):/ansible:Z \
  -v ~/.ssh:/root/.ssh:ro,Z \
  custom-ansible ansible-playbook playbook.yml -i inventory
```

### Using Docker

**Basic execution (shows Ansible help):**
```bash
docker run --rm -it custom-ansible
```

**Running an Ansible Playbook:**
```bash
docker run --rm -it \
  -v $(pwd):/ansible \
  -v ~/.ssh:/root/.ssh:ro \
  custom-ansible ansible-playbook playbook.yml -i inventory
```
