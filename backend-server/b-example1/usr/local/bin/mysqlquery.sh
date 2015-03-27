#!/bin/bash
mysql -u zabbix -psuperpassword -e "show global status like 'Com_$1'" | grep Com_$1  | awk '{print$2}'

