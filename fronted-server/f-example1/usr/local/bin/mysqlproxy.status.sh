#!/bin/bash

CONFIG='/usr/local/bin/mysqlproxy.status.conf'
LOG='/tmp/check-mysql.log'
answer="mysqld is alive"

str=""
result=false
mysqlCheck() {
        res=`mysqladmin ping -h $1 -u user -pyourpassword > /dev/null ; echo $?`
       
	str="$str\n$1:$res"
	
	if [ "$res" != $2 ]
        then
		result=true
                echo "$1 not actual status" >> $LOG
        fi
}


for line in `cat $CONFIG`
do

    #echo "Parse line $line"
    SERVER=`echo $line | cut -d \: -f 1`
    STATUS=`echo $line | cut -d \: -f 2`
    #echo "SERVER $SERVER, STATUS $STATUS"
	mysqlCheck $SERVER $STATUS

done

# Запись в файл новых значений
echo  -e $str > $CONFIG

echo "Время запуска `date`" >> $LOG
if $result; then
	echo "need restart mysqlproxy" >> $LOG
	/usr/local/bin/mysqlproxy.check.sh >> $LOG
else
	echo "not need restart " >> $LOG
fi
