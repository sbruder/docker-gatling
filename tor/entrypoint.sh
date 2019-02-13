#!/bin/ash
set -e
tor -f /etc/tor/torrc
cat /var/lib/tor/hidden_service/hostname
gatling -p 8080 -u 100 -V -d -f -p 2121 -U -S >> /dev/null
