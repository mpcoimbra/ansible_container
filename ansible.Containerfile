FROM docker.io/rockylinux/rockylinux:10.1-ubi

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.local/bin/

ARG ANSIBLE_VERSION=2.16.16

RUN dnf install -yy https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm && dnf groupinstall -y "Development Tools" && dnf install -y sshpass pipx curl wget git rsync

RUN mkdir /ansible && mkdir -p /root/{.azure,.aws} && \
    pipx install ansible-core==$ANSIBLE_VERSION && \
    pipx inject ansible-core argcomplete && \
    pipx inject --include-deps ansible-core pypsrp && \
    pipx inject  ansible-core  pyVmomi>=8.0.3.0.1 vmware-vcenter 'setuptools < 82' && \
   # pipx ensurepath && source ~/.bashrc && \
    ansible-galaxy collection install ansible.posix ansible.windows vmware.vmware community.vmware azure.azcollection


WORKDIR /ansible
ENTRYPOINT []

CMD [\"ansible\" \"--help\"]
