#!/bin/sh
. /opt/farm/scripts/init
. /opt/farm/scripts/functions.install


if [ "`uname`" != "Linux" ]; then
	echo "skipping secure kernel setup, unsupported system"
	exit 0
fi


echo "disabling ipv6"
sysctl -qp /opt/farm/ext/ip-noipv6/sysctl/noipv6.conf

if [ -d /etc/sysctl.d ]; then
	remove_link /etc/sysctl.d/noipv6.conf
	install_copy /opt/farm/ext/ip-noipv6/sysctl/noipv6.conf /etc/sysctl.d/noipv6.conf
fi

if [ -f /etc/sysctl.d/farmer-ipv6.conf ]; then
	rm -f /etc/sysctl.d/farmer-ipv6.conf
fi


if ! grep -q preferIPv4 /etc/environment; then
	echo "forcing Java virtual machines to use ipv4"
	echo 'JAVA_OPTS="-Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true"' >>/etc/environment
fi
