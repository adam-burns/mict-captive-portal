#!/bin/bash
if [ ! -f /home/pfm/pfm_conf/dnsmasq.CAPTIVE_PORTAL ]
then
    /usr/sbin/dnsmasq.bin $*
else
    logger "captive portal mode activated params: $*" 
    /usr/sbin/dnsmasq.bin --conf-file /home/pfm/pfm_conf/dnsmasq.CAPTIVE_PORTAL
    /usr/sbin/dnsmasq.bin $* --address=/#/10.42.0.1
fi
