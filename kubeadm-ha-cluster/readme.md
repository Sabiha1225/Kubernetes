

## Setup the load balancer node 
###### Install haproxy
yum update && yum install haproxy -y

###### Edit /etc/haproxy/haproxy.cfg
```
frontend kubernetes-masters
  bind *:6443
  mode tcp
  option tcplog
  default_backend kubernetes-masters
   
backend kubernetes-masters
    mode tcp
    option tcplog
    option tcp-check
    balance roundrobin
    default-server inter 10s downinter 5s rise 2 fall 2 slowstart 60s maxconn 250 maxqueue 256 weight 100
    server kmaster1 <master1-ip>:6443 
    server kmaster2 <masyer2-ip>:6443 
```

###### Restart haproxy service
systemctl restart haproxy

## Install Containerd
```
sudo su -
wget https://github.com/containerd/containerd/releases/download/v1.6.14/containerd-1.6.14-linux-amd64.tar.gz
tar Cxzvf /usr/local containerd-1.6.14-linux-amd64.tar.gz

wget https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64
install -m 755 runc.amd64 /usr/local/sbin/runc

wget https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-amd64-v1.1.1.tgz
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.1.1.tgz

mkdir -p /etc/containerd/
containerd config default | sudo tee /etc/containerd/config.toml

sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

curl -L https://raw.githubusercontent.com/containerd/containerd/main/containerd.service -o /etc/systemd/system/containerd.service

systemctl daemon-reload

systemctl start containerd
systemctl enable containerd
```
## Install Cluster with kubeadm
###### Install kubeadm, kubelet, kubectl

###### Disable Swap
swapoff -a; sed -i '/swap/d' /etc/fstab

```
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

# Set SELinux in permissive mode (effectively disabling it)
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet
```


## Cluster Creation
#### Run the below command in one of the control plane

```
kubeadm init --control-plane-endpoint "<load-balancer-ip>:6443" --upload-certs --pod-network-cidr=10.222.0.0/16 --v=9
```
