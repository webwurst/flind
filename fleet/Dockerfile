FROM fedora:23

ENV container docker

# prepare systemd for running in docker
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


RUN dnf -y update && dnf -y install openssh-server sudo pam_ssh hostname tar iproute iputils procps \
  && dnf clean all

RUN rm /tmp/* -r

# docker
ARG docker_version=1.10.3
# ARG docker_version=1.11.0
# RUN curl -fsSL -o /usr/bin/docker https://experimental.docker.com/builds/Linux/x86_64/docker-latest
RUN curl -fsSL https://get.docker.com/builds/Linux/x86_64/docker-${docker_version}.tgz \
    | tar -xz --strip-components=1 -C /tmp \
  && cp /tmp/local/bin/docker /usr/bin/
  # && cp /tmp/* /usr/bin/
  #^ FIXME! distinguish path in tar depending on version

# COPY daemon.json /etc/docker/daemon.json
RUN groupadd docker

# etcd
ARG etcd_version=2.3.1
RUN curl -fsSL https://github.com/coreos/etcd/releases/download/v${etcd_version}/etcd-v${etcd_version}-linux-amd64.tar.gz \
    | tar -xz --strip-components=1 -C /tmp \
  && cp /tmp/etcd /usr/bin/ \
  && cp /tmp/etcdctl /usr/bin/

RUN useradd -m -s /usr/bin/nologin -d /var/lib/etcd2 etcd

# fleet
ARG fleet_version=0.11.7
RUN curl -fsSL https://github.com/coreos/fleet/releases/download/v${fleet_version}/fleet-v${fleet_version}-linux-amd64.tar.gz \
    | tar -xz --strip-components=1 -C /tmp \
  && cp /tmp/fleetd /usr/bin/ \
  && cp /tmp/fleetctl /usr/bin/

# inago
ARG inago_version=0.2.2
RUN curl -fsSL https://github.com/giantswarm/inago/releases/download/${inago_version}/inagoctl.${inago_version}.linux.tar.gz \
    | tar -xz --strip-components=1 -C /tmp \
  && cp /tmp/inagoctl /usr/bin/

# kubectl
ARG kubectl_version=1.2.2
RUN curl -fsSL https://storage.googleapis.com/kubernetes-release/release/v${kubectl_version}/bin/linux/amd64/kubectl \
  -o /usr/bin/kubectl

RUN chmod u+x /usr/bin/*

# create core user
RUN useradd -m -G wheel,systemd-journal,docker -s /bin/bash core \
  && echo core:coreos | chpasswd \
  && echo "%sudo ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/core \
  && echo "core ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/core


COPY units/* /etc/systemd/system/
# COPY daemon.json /etc/docker/daemon.json
COPY etc/* /etc/
COPY sbin/* /usr/sbin/

RUN systemctl enable \
  sshd.service etcd2.service fleet.service docker.service \
  setup-env-files.service

# RUN rm /etc/machine-id || true

VOLUME [ "/sys/fs/cgroup" ]
# VOLUME [ "/var/lib/docker" ]
CMD ["/usr/sbin/init"]
