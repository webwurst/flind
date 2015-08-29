
docker build --rm -t local/systemd-docker .

  # docker run -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro local/systemd-docker /usr/lib/systemd/systemd

docker run --privileged -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro local/systemd-docker

---

docker build -f Dockerfile_fedora --rm -t local/systemd-docker-fedora .

docker run --privileged --rm -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro local/systemd-docker-fedora
docker ps

docker exec -t -i ${CONTAINER} /bin/bash
