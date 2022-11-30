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
# sed -e 's#accesslog.filename = "/var/log/lighttpd/access.log"#accesslog.filename = "/home/pfm/pfm_store/var/log/lighttpd/access.log"#g' /etc/lighttpd/conf-available/10-accesslog.conf > /etc/lighttpd/conf-available/10-accesslog.conf
# cd /etc/lighttpd/conf-enabled
# ln -s ../conf-available/10-accesslog.conf .
# cd -
systemctl enable lighttpd
echo "lighhtpd enabled"

mount -o ro,remount /
su - pfm -c "mkdir -p /home/pfm/pfm_store/var/log/lighttpd"
su - pfm -c "mkdir -p /home/pfm/pfm_store/var/www"
chown www-data /home/pfm/pfm_store/var/log/lighttpd
#cp -pr var/www/* /home/pfm/pfm_store/var/www
chown -R pfm:pfm /home/pfm/pfm_store/var/www
#sed -e s/pfm009.local/${HOSTNAME}.local/g var/www/html/index.html >/home/pfm/pfm_store/var/www/html/index.html
#sed -e s/pfm009.local/${HOSTNAME}.local/g var/www/html/index.php >/home/pfm/pfm_store/var/www/html/index.php
#echo "example content loaded"
systemctl start lighttpd
echo "lighttpd started"
echo "delete /home/pfm/pfm_conf/dnsmasq.CAPTIVE_PORTAL to stop captive portal"
