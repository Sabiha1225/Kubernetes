

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

##Install Containerd
```
sudo su -
wget https://github.com/containerd/containerd/releases/download/v1.6.14/containerd-1.6.14-linux-amd64.tar.gz
tar Cxzvf /usr/local containerd-1.6.14-linux-amd64.tar.gz

wget https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64
install -m 755 runc.amd64 /usr/local/sbin/runc

wget https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-amd64-v1.1.1.tgz
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.1.1.tgz
```
