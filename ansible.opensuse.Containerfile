# ==========================================
# Stage 1: Builder
# ==========================================
# Use opensuse-leap 16 as the build environment to compile and install Ansible and its dependencies
FROM docker.io/opensuse/leap:16 AS builder

# Set PATH to include pipx binaries in /root/.local/bin
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.local/bin/

# Default Ansible version, can be overridden with --build-arg ANSIBLE_VERSION=<version>
ARG ANSIBLE_VERSION=2.16.16

# Install necessary packages
RUN zypper update -y && \
    zypper --non-interactive install -yy sshpass python313-pipx curl wget git rsync

# Set up directories, install ansible-core via pipx, inject required Python dependencies,
# and install necessary Ansible collections along with their requirements
RUN  mkdir -p /root/{.azure,.aws} && \
    pipx install ansible-core==${ANSIBLE_VERSION} && \
    pipx inject ansible-core argcomplete && \
    pipx inject --include-deps ansible-core pypsrp && \
    pipx inject ansible-core pyVmomi>=8.0.3.0.1 vmware-vcenter 'setuptools < 82' && \
    ansible-galaxy collection install ansible.posix ansible.windows vmware.vmware community.vmware azure.azcollection && \
    pipx runpip ansible-core install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements.txt


# ==========================================
# Stage 2: Final Runtime Image
# ==========================================
# Use a fresh Rocky Linux 10 UBI image for the runtime container
FROM docker.io/opensuse/leap:16

# Set PATH to include pipx binaries copied into /root/.local/bin
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.local/bin/

# Install necessary packages
RUN zypper update -y && \
    zypper --non-interactive install  -yy sshpass python313-pipx curl wget git rsync

# Copy the entire /root/ home directory (including pipx venvs, binaries, and collections) from the builder stage
COPY --from=builder /root/ /root/

# Set the working directory for mounting playbooks
WORKDIR /ansible

# Reset entrypoint and set default command
ENTRYPOINT []
CMD ["ansible", "--help"]
