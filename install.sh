#!/bin/bash
mount -o rw,remount /
cp -p /usr/sbin/dnsmasq /usr/sbin/dnsmasq.bin
cp dnsmasq.sh /usr/sbin/dnsmasq
mount -o ro,remount /
touch /home/pfm/pfm_conf/dnsmasq.CAPTIVE_PORTAL
echo "dnsmasq shell interceptor for NetworkManager installed"
echo "delete /home/pfm/pfm_conf/dnsmasq.CAPTIVE_PORTAL to stop captive portal"
