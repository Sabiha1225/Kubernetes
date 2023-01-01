#!/bin/bash
# Kube Admin Reset
kubeadm reset

# Remove all packages related to Kubernetes
yum remove -y kubeadm kubectl kubelet kubernetes-cni kube* 

# Remove docker containers/ images ( optional if using docker)
docker image prune -a
yum remove -y docker-engine docker docker.io docker-ce docker-ce-cli containerd containerd.io runc

# Remove parts
yum autoremove -y

# Remove all folder associated to kubernetes, etcd, and docker
rm -rf ~/.kube
rm -rf /etc/cni /var/lib/cni/ /etc/kubernetes /var/lib/dockershim /var/lib/etcd /var/lib/kubelet /var/lib/etcd2/ /var/run/kubernetes ~/.kube/* 
rm -rf /var/lib/docker /etc/docker /var/run/docker.sock
rm -f /etc/apparmor.d/docker /etc/systemd/system/etcd* 

# Delete docker group (optional)
groupdel docker

# Clear the iptables
iptables -F && iptables -X
iptables -t nat -F && iptables -t nat -X
iptables -t raw -F && iptables -t raw -X
iptables -t mangle -F && iptables -t mangle -X
