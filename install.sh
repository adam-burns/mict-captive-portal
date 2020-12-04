#!/bin/bash
if [ -f /usr/sbin/dnsmasq.bin ]; then
    echo "/usr/sbin/dnsmasq.bin exists. Aborting."
    exit 0
fi
mount -o rw,remount /
cp -p /usr/sbin/dnsmasq /usr/sbin/dnsmasq.bin
cp dnsmasq.sh /usr/sbin/dnsmasq
chmod a+x /usr/sbin/dnsmasq
touch /home/pfm/pfm_conf/dnsmasq.CAPTIVE_PORTAL
echo "dnsmasq shell interceptor for NetworkManager installed"
systemctl enable lighttpd
echo "lighhtpd enabled"
mount -o ro,remount /
su - pfm -c "mkdir -p /home/pfm/pfm_store/var/log/lighttpd"
chown www-data /home/pfm/pfm_store/var/log/lighttpd
systemctl start lighttpd
echo "lighhtpd started"
echo "delete /home/pfm/pfm_conf/dnsmasq.CAPTIVE_PORTAL to stop captive portal"
