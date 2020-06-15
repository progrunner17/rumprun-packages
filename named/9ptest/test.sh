#!/bin/bash
set -eux

if ! [ -e "/sys/class/net/tap10" ]; then
  sudo ip tuntap add mode tap tap10
fi
if [ -z "$(ip addr show tap10 | grep inet | grep 172)" ]; then
  sudo ip addr add 172.18.0.1/24 dev tap10
fi
sudo ip link set up dev tap10

cat > lkl.json <<-'EOF'
{
    "gateway": "172.18.0.1",
    "interfaces": [
        {
            "ip": "172.18.0.2",
            "masklen": "24",
            "name": "tap10",
            "type": "rumpfd"
        }
    ],
    "debug": "1",
    "singlecpu": "1",
    "delay_main": "50000",

}
EOF

cid=$(docker run -d --rm -e RUMP_VERBOSE=1 -e DEBUG=1 --runtime=runu-dev --net=none \
  -e LKL_USE_9PFS=1 \
  -e LKL_NET=tap10 \
  -e LKL_CONFIG=$PWD/lkl.json \
  runu-named \
  named -c /etc/named/named.conf -g)



while !(ping -c 1 172.18.0.2 2>/dev/null >/dev/null); do
  sleep 1
done
nslookup ns.hoge.local 172.18.0.2
nslookup host.hoge.local 172.18.0.2
docker kill ${cid}
