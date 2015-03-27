#!/bin/bash

CONFIG='/usr/local/bin/mysqlproxy.setdb.conf'
#proxy=10.1.2.8
proxy=0.0.0.0
#master=b-example1
#slave=b-example2

master=""
slave=""

if [ ! -e $1 ]
then
	master="--proxy-backend-addresses=$1:3306"		
fi

if [ ! -e $2 ]
then
	slave="--proxy-read-only-backend-addresses=$2:3306"
fi

echo "Killall MySQL Proxy"
`killall -9 mysql-proxy`

for line in `cat $CONFIG`
do
PORT=`echo $line | cut -d \: -f 3 | tr -d '\r'`
echo "Start MySQL Proxy on PORT - $PORT"

mysql-proxy --daemon \
$master \
$slave \
--proxy-address=$proxy:$PORT \
--log-file=/var/log/mysql/mysql-proxy_$PORT.log \
--log-level=debug \
--plugin-dir=/usr/lib/mysql-proxy/plugins/ \
--plugins=proxy \
--proxy-lua-script=/usr/lib/mysql-proxy/lua/rw-splitting.lua \
--event-threads=10 \
--proxy-skip-profiling \
--proxy-fix-bug-25371 \
--keepalive


#echo ${arr[$i]};
done

