#!/bin/bash
echo "mysql pass ";
read p

echo "replication pass "
read pr

host1="b-example1"
host2="b-example2"
user1="root"
pass1="$p"
user2="root"
pass2="$p"
db="db1 db2 db3 db4 db5 db6"
dd=$(date +"%m-%d-%Y_%H:%m")
dump=tmpsql.sql
userrepl="replication"
passrepl="$pr"

echo "Script start `date`"

mysql -u$user1 -p$pass1 -h $host1 -e "stop slave"
mysql -u$user2 -p$pass2 -h $host2 -e "stop slave"
mysql -u$user2 -p$pass2 -h $host2 -e "reset slave"

mysql -u$user1 -p$pass1 -h $host1 -e "GRANT REPLICATION SLAVE ON *.* TO '$userrepl'@'$host2' IDENTIFIED BY '$passrepl';"
mysql -u$user2 -p$pass2 -h $host2 -e "GRANT REPLICATION SLAVE ON *.* TO '$userrepl'@'$host1' IDENTIFIED BY '$passrepl';"

# host1
# host1 to host2
mysql -u$user1 -p$pass1 -h $host1 -e "FLUSH TABLES WITH READ LOCK;"
mysql -u$user1 -p$pass1 -h $host1 -e "SET GLOBAL read_only = ON;"
mysqldump -u$user1 -p$pass1 -h $host1 -B $db > $dump
file1=$(mysql -u$user1 -p$pass1 -h $host1 -e "SHOW MASTER STATUS;" | grep 'mysql*' | cut -f1)
pos1=$(mysql -u$user1 -p$pass1 -h $host1 -e "SHOW MASTER STATUS;" | grep 'mysql*' | cut -f2)
mysql -u$user1 -p$pass1 -h $host1 -e "SET GLOBAL read_only = OFF;"
mysql -u$user1 -p$pass1 -h $host1 -e "UNLOCK TABLES;"

# host2
mysql -u$user2 -p$pass2 -h $host2 < $dump

mysql -u$user2 -p$pass2 -h $host2 -e "CHANGE MASTER TO master_host='$host1', master_port=3306, master_user='$userrepl', master_password='$passrepl', master_log_file='$file1', master_log_pos=$pos1;" 
mysql -u$user2 -p$pass2 -h $host2 -e "start slave"
echo "Server: $host2 "$(mysql -u$user2 -p$pass2 -h $host2 -e "show slave status \G;" | grep 'Slave*')

# host2 to host1
file2=$(mysql -u$user2 -p$pass2 -h $host2 -e "SHOW MASTER STATUS;" | grep 'mysql*' | cut -f1)
pos2=$(mysql -u$user2 -p$pass2 -h $host2 -e "SHOW MASTER STATUS;" | grep 'mysql*' | cut -f2)

mysql -u$user1 -p$pass1 -h $host1 -e "CHANGE MASTER TO master_host='$host2', master_port=3306, master_user='$userrepl', master_password='$passrepl', master_log_file='$file2', master_log_pos=$pos2;"

mysql -u$user1 -p$pass1 -h $host1 -e "start slave"
echo "Server: $host1 "$(mysql -u$user1 -p$pass1 -h $host1 -e "show slave status \G;" | grep 'Slave*')

rm $dump

echo "Script end `date`"
