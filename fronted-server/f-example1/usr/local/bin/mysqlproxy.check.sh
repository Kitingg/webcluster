#!/bin/bash


# start Parametrs
arrayIp=(b-example1 b-example2)
virtualIp=10.1.2.8
mysqlAnswer='mysqld is alive'
host=`/sbin/ifconfig eth0:0 | awk -F ' *|:' '/inet addr/{print $4}'`
params=""
mysqlCheck() {
	res=`mysqladmin ping -h $1 -u user -pyourpassword`
	if [ "$res" == "$mysqlAnswer" ]
	then
        	params="$params $1"
	fi

}
# end Parametrs

# check virtualIp 
if [  -e $host ] 
then
	echo "not host"
#	exit
else
	if [ $host != $virtualIp ]
	then
		echo "host != virtual ip"
#		exit
	fi
fi
# loop ip address
for item in ${arrayIp[*]}
do
	mysqlCheck $item
done

echo "Server is $params"

mysqlproxy.start.sh $params
