FROM fedora:23

ENV container docker

# RUN apt-get update && apt-get install -y systemd-services dbus fleet docker.io \
#   iputils-ping curl jq


# COPY docker.repo /etc/yum.repos.d/

# RUN dnf -y update && dnf -y install openssh-server sudo iproute docker-engine \
RUN dnf -y update && dnf -y install openssh-server sudo iproute \
  && dnf clean all

RUN ( \
    cd /lib/systemd/system/sysinit.target.wants/; \
    for i in *; do \
      if [ "$i" != "systemd-tmpfiles-setup.service" ]; then \
        rm -f $i; \
      fi \
    done \
    ) \
    && rm -f /lib/systemd/system/multi-user.target.wants/* \
    && rm -f /etc/systemd/system/*.wants/* \
    && rm -f /lib/systemd/system/local-fs.target.wants/* \
    && rm -f /lib/systemd/system/sockets.target.wants/*udev* \
    && rm -f /lib/systemd/system/sockets.target.wants/*initctl* \
    && rm -f /lib/systemd/system/anaconda.target.wants/* \
    && rm -f /lib/systemd/system/basic.target.wants/* \
    && rm -f /lib/systemd/system/graphical.target.wants/* \
		&& rm -f /lib/systemd/system/anaconda.target.wants/* \
    && ln -vf /lib/systemd/system/multi-user.target /lib/systemd/system/default.target

# add user core
RUN groupadd docker
RUN useradd -m -G wheel,systemd-journal,docker -s /bin/bash core \
  && echo core:coreos | chpasswd \
  && echo "%sudo ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/core \
  && echo "core ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/core

# add user etcd
RUN useradd -m -s /usr/bin/nologin -d /var/lib/etcd2 etcd

RUN dnf -y install tar

ARG docker_version=1.10.3
RUN curl -fsSL https://get.docker.com/builds/Linux/x86_64/docker-${docker_version}.tgz \
    | tar -xz --strip-components=1 -C /tmp \
  && cp /tmp/local/bin/docker /usr/bin/
  #^ FIXME! distinguish path in tar depending on version

ARG etcd_version=2.3.1
RUN curl -fsSL https://github.com/coreos/etcd/releases/download/v${etcd_version}/etcd-v${etcd_version}-linux-amd64.tar.gz \
    | tar -xz --strip-components=1 -C /tmp \
  && cp /tmp/etcd /usr/bin/ \
  && cp /tmp/etcdctl /usr/bin/

ARG fleet_version=0.11.7
RUN curl -fsSL https://github.com/coreos/fleet/releases/download/v${fleet_version}/fleet-v${fleet_version}-linux-amd64.tar.gz \
    | tar -xz --strip-components=1 -C /tmp \
  && cp /tmp/fleetd /usr/bin/ \
  && cp /tmp/fleetctl /usr/bin/

ARG inago_version=0.2.2
RUN curl -fsSL https://github.com/giantswarm/inago/releases/download/${inago_version}/inagoctl.${inago_version}.linux.tar.gz \
    | tar -xz --strip-components=1 -C /tmp \
  && cp /tmp/inagoctl /usr/bin/


# "install" etcd and fleet binaries
# COPY etcd-v2.3.1/etcd /usr/bin/
# COPY etcd-v2.3.1/etcdctl /usr/bin/
# COPY fleet-v0.11.7/fleetd /usr/bin/
# COPY fleet-v0.11.7/fleetctl /usr/bin/
# COPY docker-1.10.3/docker /usr/bin/

RUN chmod u+x /usr/bin/*

# RUN rm /lib/systemd/system/docker.service
COPY units/* /etc/systemd/system/

ADD setup-env-files.service /etc/systemd/system/setup-env-files.service
ADD setup-env-files /usr/sbin/setup-env-files
# ADD etcd2.service /etc/systemd/system/etcd2.service
# ADD fleet.service /etc/systemd/system/fleet.service
# ADD fleet.socket /etc/systemd/system/fleet.socket
# ADD nomi /home/core/nomi
# RUN chmod +x /home/core/nomi

# RUN systemctl enable sshd.service
# RUN systemctl enable setup-env-files.service
# RUN systemctl enable etcd2.service
# RUN systemctl enable fleet.service
RUN systemctl enable \
  sshd.service etcd2.service fleet.service docker.service \
  setup-env-files.service

RUN rm /etc/machine-id || true

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
