#!/bin/sh

echo 'Download Last Version for next execute'

curl -v -H 'Cache-Control: no-cache' -L -o /root/itfinden_service.update https://raw.githubusercontent.com/itfinden/disable_cpanel_service/main/itfinden_service.sh

function disable_service(){
   cd /root
for service in \
   aibolit-resident\
   abrt-ccpp\
   abrt-oops\
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

mv /root/itfinden_service.update /root/itfinden_service.sh

crontab -l | grep '/root/itfinden_service.sh' 1>/dev/null 2>&1
(( $? == 0 )) && exit
crontab -l >/tmp/crontab.tmp
echo '* 2 * * * sh /root/itfinden_service.sh > /dev/null 2>&1' >>/tmp/crontab.tmp
crontab /tmp/crontab.tmp
rm /tmp/crontab.tmp

mv -f /root/itfinden_service.update /root/itfinden_service.sh 
