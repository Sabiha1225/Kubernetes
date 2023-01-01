

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
