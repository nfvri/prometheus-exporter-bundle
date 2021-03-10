#!/bin/bash
echo "This scripts assumes that:"
echo "  - docker is installed and accessible for the current user"
echo "  - apt is installed and accessible for the current user"
echo "PLEASE: run with sudo if installation fails!"

echo "--> Initiating Ubuntu install - extra packages"
apt update && apt install moreutils ipmitool bpfcc-tools linux-headers-$(uname -r) linux-tools-generic

echo "--> Run opcm/pcm in docker..."
docker run -d --name pcm --privileged -p 9101:9738 opcm/pcm

echo "--> Run sriov-exporter..."
./sriov-exporter -web.listen-address ":9102" 2>&1 | logger -t "sriov-exporter" &

echo "--> Run prometheus-libvirt-exporter..."
./prometheus-libvirt-exporter -web.listen-address ":9103" 2>&1 | logger -t "prometheus-libvirt-exporter" &

echo "--> Run ebpf_exporter..."
./ebpf_exporter --web.listen-address=":9104" --config.file=config.yaml 2>&1 | logger -t "ebpf_exporter" &

echo "--> Run node_exporter..."
./node_exporter --web.listen-address=":9100"  --collector.textfile.directory="$(pwd)" 2>&1  | logger -t "node_exporter" &

while true; 
do 
	ipmitool sensor | ./ipmitool | sponge ipmitool.prom
        sleep 3
done

