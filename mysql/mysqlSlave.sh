#!/bin/bash
#
set -o nounset
set -o errexit

# 主机地址/IP
MYSQL_HOST='127.0.0.1'
 
# 端口
MYSQL_PORT='3306'
#
MYSQL_DIR="/usr/local/mysql" 
# 数据连接
MYSQL_CONN="$MYSQL_DIR/bin/mysqladmin -h${MYSQL_HOST} -P${MYSQL_PORT}"
MYSQL_QUERY="$MYSQL_DIR/bin/mysql -h${MYSQL_HOST} -P${MYSQL_PORT}"
 
# 参数是否正确
if [ $# -ne "1" ];then 
    echo "arg error!" 
fi 
 
# 获取数据
case $1 in 
   Slave_delay)
        result=`${MYSQL_QUERY} -e 'show slave status\G' |grep -E "Seconds_Behind_Master:"|awk '{print $2}'`
        echo $result
        ;;
   Slave_running_status)
        result=`${MYSQL_QUERY} -e 'show slave status\G' |grep -E "Slave_IO_Running:|Slave_SQL_Running:"|grep -c "Yes"`
        echo $result
        ;;
    Uptime) 
        result=`${MYSQL_CONN} status|cut -f2 -d":"|cut -f1 -d"T"` 
        echo $result 
        ;; 
    Com_update) 
        result=`${MYSQL_CONN} extended-status |grep -w "Com_update"|cut -d"|" -f3` 
        echo $result 
        ;; 
    Slow_queries) 
        result=`${MYSQL_CONN} status |cut -f5 -d":"|cut -f1 -d"O"` 
        echo $result 
        ;; 
    Com_select) 
        result=`${MYSQL_CONN} extended-status |grep -w "Com_select"|cut -d"|" -f3` 
        echo $result 
                ;; 
    Com_rollback) 
        result=`${MYSQL_CONN} extended-status |grep -w "Com_rollback"|cut -d"|" -f3` 
                echo $result 
                ;; 
    Questions) 
        result=`${MYSQL_CONN} status|cut -f4 -d":"|cut -f1 -d"S"` 
                echo $result 
                ;; 
    Com_insert) 
        result=`${MYSQL_CONN} extended-status |grep -w "Com_insert"|cut -d"|" -f3` 
                echo $result 
                ;; 
    Com_delete) 
        result=`${MYSQL_CONN} extended-status |grep -w "Com_delete"|cut -d"|" -f3` 
                echo $result 
                ;; 
    Com_commit) 
        result=`${MYSQL_CONN} extended-status |grep -w "Com_commit"|cut -d"|" -f3` 
                echo $result 
                ;; 
    Bytes_sent) 
        result=`${MYSQL_CONN} extended-status |grep -w "Bytes_sent" |cut -d"|" -f3` 
                echo $result 
                ;; 
    Bytes_received) 
        result=`${MYSQL_CONN} extended-status |grep -w "Bytes_received" |cut -d"|" -f3` 
                echo $result 
                ;; 
    Com_begin) 
        result=`${MYSQL_CONN} extended-status |grep -w "Com_begin"|cut -d"|" -f3` 
                echo $result 
                ;; 
                        
        *) 
        echo "Usage:$0(Uptime|Com_update|Slow_queries|Com_select|Com_rollback|Questions|Com_insert|Com_delete|Com_commit|Bytes_sent|Bytes_received|Com_begin)" 
        ;; 
esac
