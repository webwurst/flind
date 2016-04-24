
fix access right on /home/core/.ssh/authorized_keys ?
  # RUN chmod u=rwx,g=,o= /home/core/.ssh || true \
  #   && chmod u=rw,g=,o= /home/core/.ssh/authorized_keys || true
  Before=sshd


sshd_config
  PermitRootLogin yes
  #PubkeyAuthentication yes
  PasswordAuthentication yes
  #AllowAgentForwarding yes


/usr/bin/fleetctl list-units -fields=unit,machine --full --no-legend 2>/dev/null | grep ^k8s-master-api-server.service | cut -d/ -f2 | paste -d, -s



```
/usr/bin/docker run \
  --rm --net=host --privileged=true \
  -v /usr/share/ca-certificates:/etc/ssl/certs \
  giantswarm/k8s-proxy:1.2.0 \
    --master=172.20.0.4:8080 --logtostderr=true --v=2

I0421 22:35:28.988689       1 iptables.go:177] Could not connect to D-Bus system bus: dial unix /var/run/dbus/system_bus_socket: no such file or directory
I0421 22:35:28.988730       1 server.go:154] setting OOM scores is unsupported in this build
E0421 22:35:28.991510       1 server.go:340] Can't get Node "e571be73b85a", assuming iptables proxy: nodes "e571be73b85a" not found
I0421 22:35:28.992474       1 server.go:200] Using iptables Proxier.
I0421 22:35:28.992524       1 server.go:213] Tearing down userspace rules.
I0421 22:35:29.001783       1 conntrack.go:36] Setting nf_conntrack_max to 262144
I0421 22:35:29.001834       1 conntrack.go:41] Setting conntrack hashsize to 65536
write /sys/module/nf_conntrack/parameters/hashsize: operation not supported
```



---

Could not connect to D-Bus system bus: dial unix /var/run/dbus/system_bus_socket: no such file or directory


Apr 21 15:13:33 17caacc5120b docker[32]: time="2016-04-21T15:13:33.750660781Z" level=warning msg="Running modprobe bridge br_netfilter failed with message: modprobe
: WARNING: Module bridge not found in directory /lib/modules/4.5.0-2-MANJARO\nmodprobe: WARNING: Module br_netfilter not found in directory /lib/modules/4.5.0-2-MAN
JARO\n, error: exit status 1"


$ sudo docker daemon --exec-opt native.cgroupdriver=systemd


# RUN apt-get update && apt-get install -y systemd-services dbus fleet docker.io \
#   iputils-ping curl jq


https://github.com/docker/docker/issues/18796#issuecomment-204462440

https://github.com/ome/ome-docker/pull/36
https://github.com/ome/ome-docker/blob/master/omero-ssh-systemd/Dockerfile


coreos-setup-environment.service
  https://github.com/coreos/init/blob/master/systemd/system/coreos-setup-environment.service


cat > /etc/environment <<EOF
COREOS_PRIVATE_IPV4=10.0.4.104
EOF

echo "" > /etc/network-environment

cat > /etc/fleet-cluster-env <<EOF
LO_IPV4=127.0.0.1
DOCKER0_IPV4=172.17.0.1
ETH0_IPV4=172.20.0.3
DEFAULT_IPV4=172.20.0.3
EOF


cat > /etc/fleet-cluster-env <<EOF
ETCD_ADVERTISE_CLIENT_URLS=http://${ipaddr}:2379
ETCD_DISCOVERY=${ETCD_DISCOVERY}
ETCD_INITIAL_ADVERTISE_PEER_URLS=http://${ipaddr}:2380
ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379,http://0.0.0.0:4001
ETCD_LISTEN_PEER_URLS=http://${ipaddr}:2380,http://${ipaddr}:7001
FLEET_ETCD_SERVERS=http://${ipaddr}:2379
FLEET_METADATA=${fleet_metadata}
EOF
