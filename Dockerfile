FROM centos:centos7

ENV container docker

RUN yum -y update \
  && yum -y swap -- remove systemd-container systemd-container-libs -- install systemd systemd-libs dbus \
  && yum clean all

RUN systemctl mask dev-mqueue.mount dev-hugepages.mount \
    systemd-remount-fs.service sys-kernel-config.mount \
    sys-kernel-debug.mount sys-fs-fuse-connections.mount \
    display-manager.service graphical.target systemd-logind.service

ADD dbus.service /etc/systemd/system/dbus.service
RUN systemctl enable dbus.service

VOLUME ["/sys/fs/cgroup"]
VOLUME ["/run"]
# CMD ["/usr/lib/systemd/systemd"]


RUN yum -y update && yum -y install docker ; yum clean all
# RUN yum -y update && yum -y --enablerepo=centosplus install docker && yum clean all
# RUN curl -SL -o /usr/local/bin/docker https://get.docker.com/builds/Linux/x86_64/docker-1.8.1 \
#   && chmod +x /usr/local/bin/docker

ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker
# VOLUME /var/lib/docker

CMD ["wrapdocker"]
