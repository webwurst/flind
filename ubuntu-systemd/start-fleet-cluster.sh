#!/bin/env fish

set -x ETCD_DISCOVERY (curl -fsS "https://discovery.etcd.io/new?size=3")
# ETCD_DISCOVERY=$(curl -fsS "https://discovery.etcd.io/new?size=3")
echo "\$ETCD_DISCOVERY: $ETCD_DISCOVERY"

docker-compose up -d
docker-compose scale fleet=3

# docker exec ubuntusystemd_fleet_1 /bin/sh -c "systemctl start etcd &"
docker exec ubuntusystemd_fleet_1 systemctl start etcd &
# docker exec ubuntusystemd_fleet_1 systemctl start etcd fleet
docker exec ubuntusystemd_fleet_2 systemctl start etcd &
# docker exec ubuntusystemd_fleet_2 systemctl start etcd fleet
docker exec ubuntusystemd_fleet_3 systemctl start etcd &
# docker exec ubuntusystemd_fleet_3 systemctl start etcd fleet

docker exec ubuntusystemd_fleet_1 systemctl start fleet
docker exec ubuntusystemd_fleet_2 systemctl start fleet
docker exec ubuntusystemd_fleet_3 systemctl start fleet

# curl -fsS $ETCD_DISCOVERY | jq '.node.nodes | length'
# sleep 1
# curl -fsS $ETCD_DISCOVERY | jq '.node.nodes | length'
# sleep 1
# curl -fsS $ETCD_DISCOVERY | jq '.node.nodes | length'
sleep 1


docker exec ubuntusystemd_fleet_3 etcdctl member list
docker exec ubuntusystemd_fleet_3 fleetctl list-units

curl -fsS $ETCD_DISCOVERY | jq '.'

fleetctl --endpoint http://172.19.0.4:2379 list-units



fleetctl --endpoint http://172.19.0.4:2379 start myapp.service

fleetctl --endpoint http://172.19.0.4:2379 start apache@1
fleetctl --endpoint http://172.19.0.4:2379 start apache@2

fleetctl --endpoint http://172.19.0.4:2379 list-units
