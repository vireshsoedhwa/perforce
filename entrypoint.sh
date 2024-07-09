#!/bin/sh
set -e 

if [ -z "$P4USER" ] || [ -z "$P4PASSWD" ] || [ -z "$P4SERVICENAME" ] ; then
    >&2 echo "important ENV's are not set"
    exit 1
fi

if [ -f /etc/perforce/p4dctl.conf.d/$P4SERVICENAME.conf ]; then
    echo " previous config File FOUND for: $P4SERVICENAME "
    service helix-p4dctl restart
    echo "yes" | p4 trust
    echo $P4PASSWD | p4 login
else
    echo " config file not found for: $P4SERVICENAME creating ..."
    /opt/perforce/sbin/configure-helix-p4d.sh -n $P4SERVICENAME -p $P4PORT -u $P4USER -P $P4PASSWD --case 0 ;
fi

p4 configure set net.rfc3484=1;
p4 typemap -i < /app/typemap

>&2 echo "Starting perforce..."

exec "$@"