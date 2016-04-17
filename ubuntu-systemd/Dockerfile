# coreos base container
#
# docker run --rm -it \
# --cap-add SYS_ADMIN \
# --security-opt seccomp:/path/to/systemd-seccomp.json \
# --tmpfs /run:rw --tmpfs /tmp:rw \
# -e "container=coreos-rootfs" \
# -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
# jess/coreos
FROM ubuntu:16.04

ENV container=docker

# ADD coreos-766.5.0.tar.xz /
# RUN apt-get update && apt-get install -y systemd-services dbus fleet seccomp
RUN apt-get update && apt-get install -y systemd-services dbus fleet docker.io \
	iputils-ping curl jq
# COPY ./certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

# because of bug https://bugs.launchpad.net/ubuntu/+source/fleet/+bug/1568902
RUN curl -SL https://github.com/coreos/fleet/releases/download/v0.11.7/fleet-v0.11.7-linux-amd64.tar.gz \
	  | tar -xz -C /tmp --strip-components 1 \
	&& cp tmp/fleetd /usr/sbin/fleetd \
	&& rm /tmp/*

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
		&& ln -vf /lib/systemd/system/multi-user.target /lib/systemd/system/default.target

# RUN systemctl enable fleet

# COPY start-etcd.sh /usr/local/bin/
COPY setup-network-environment.service /lib/systemd/system/
COPY etcd.service /lib/systemd/system/

RUN rm /etc/machine-id /var/lib/dbus/machine-id

# systemd needs a different stop signal
STOPSIGNAL SIGRTMIN+3

CMD ["/sbin/init"]
