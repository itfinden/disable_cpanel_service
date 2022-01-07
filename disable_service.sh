#!/bin/sh

function disable_service(){
	cd /root
for service in \
   aibolit-resident\
   fastmail ;
   do
echo "Desactivando el service: ${service}"

systemctl disable ${service} &>/dev/null


#/sbin/chkconfig ${service} off &>/dev/null
#/sbin/service ${service} stop &>/dev/null
done
/scripts/restartsrv_chkservd
}

disable_service


crontab -l | grep '/root/itfinden_service.sh' 1>/dev/null 2>&1
(( $? == 0 )) && exit
crontab -l >/tmp/crontab.tmp
echo '30 * * * * sh /root/itfinden_service.sh > /dev/null 2>&1' >>/tmp/crontab.tmp
crontab /tmp/crontab.tmp
rm /tmp/crontab.tmp


