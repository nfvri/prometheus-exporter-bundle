# SR-IOV Network Metrics Exporter

Check the SR-IOV exporter at https://github.com/intel/sriov-network-metrics-exporter.

In this repo there is an extra file for running the exporter with docker-compose.
In addition, we set the collector.netlink=false (in docker-compose.yml and daemonset.yaml).
In the Dockerfile, we have changed the base golang image.
The docker image is in Dockerhub at nfvri/sriov-network-metrics-exporter and we use it at
docker-compose.yml and daemonset.yaml.
